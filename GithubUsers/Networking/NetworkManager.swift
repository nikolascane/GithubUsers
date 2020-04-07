//
//  NetworkManager.swift
//  GithubUsers
//
//  Created by Nik Cane on 03.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import Foundation

enum NetworkError: Swift.Error, CustomStringConvertible {
  case noConnection
  case wrongUrl(String)
  case timeout
  case serverIsUnavailable
  case pageNotFound
  case noData
  case parseError(String)
  case unknown
  
  var description: String {
    switch self {
    case .noConnection:
      return "Check your connection & try later"
    case .wrongUrl(let url):
      return "Wrong URL: \(url)"
    case .timeout:
      return "Request timeout"
    case .serverIsUnavailable:
      return "Server currently is down. Take a rest for a while"
    case .pageNotFound:
      return "App asks for a page which is not exists"
    case .noData:
      return "Looks like there is no data to show"
    case .parseError(let error):
      return "Data is probably corrupted: \(error)"
    case .unknown:
      return "An unknown error has occured!"
    }
  }
}

class NetworkManager: NSObject {
//  private let lock =
  private let serialQueue = DispatchQueue(label: "GithubUsers.queue")//, attributes: .concurrent)
  
  static let shared = NetworkManager()
  
  private var downloads = [URL: Download]()
  
  private var session = URLSession(configuration: .default)
    
  func performRequest<Requestable: RequestProtocol>(_ request: Requestable,
                      responseCompletion: @escaping (Result<URL, NetworkError>)->()) {
    guard Reachability.isConnectedToNetwork() else {
      responseCompletion(Result.failure(NetworkError.noConnection))
      return
    }
    guard let url = request.url else {
      responseCompletion(Result.failure(NetworkError.wrongUrl(request.host.rawValue)))
      return
    }
    let urlRequest = URLRequest(url: url,
                                cachePolicy: .returnCacheDataElseLoad,
                                timeoutInterval: request.timeout)
  
    let task = self.session.dataTask(with: urlRequest, completionHandler: self.requestHandler())
    let downloadTask = Download(requestUrl: url, task: task)
    
    downloadTask.task.resume()
    downloadTask.downloading = true
    downloadTask.request = request
    downloadTask.finished = responseCompletion
    self.serialQueue.sync {
      NetworkManager.shared.downloads[url] = downloadTask
    }
  }
  
  private func requestHandler() -> (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()  {
    return { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
      guard let self = self else { return }
      if let response = response as? HTTPURLResponse,
        let error = self.errorHandler(from: response),
        let url = response.url,
        let downloadTask = self.downloads[url]{
        if self.needsRepeat(errorCode: response.statusCode),
          downloadTask.attempts < 3 {
          downloadTask.attempts += 1
          downloadTask.repeatRequest()
        }
        else {
          downloadTask.downloading = false
          downloadTask.finished?(Result.failure(error))
        }
      }
      else if let data = data, let url = response?.url {
        self.serialQueue.sync {
          self.storeData(data, toUrl: url)
        }
      }
    }
  }
  
}
//MARK: Error Handle
extension NetworkManager {
  private func errorHandler(from error: HTTPURLResponse) -> NetworkError? {
    switch error.statusCode {
    case 404:
      return NetworkError.pageNotFound
    case 408:
      return NetworkError.timeout
    case 500...503:
      return NetworkError.serverIsUnavailable
    default:
      return nil
    }
  }
  
  private func needsRepeat(errorCode: Int) -> Bool {
    return errorCode == 408
  }
}
//MARK: Storage
extension NetworkManager {
  private func storeData(_ data: Data, toUrl sourceUrl: URL) {
    
    let downloadTask = self.downloads[sourceUrl]
    self.downloads[sourceUrl] = nil
    
    guard let destinationURL = PathManager.namedDirectory(for: sourceUrl, ext: "data") else {
      return
    }
    
    try? PathManager.removeAt(destinationURL)
    do {
      try data.write(to: destinationURL)
      downloadTask?.downloading = false
      downloadTask?.finished?(Result.success(destinationURL))
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
  }
}
