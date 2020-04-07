//
//  Download.swift
//  GithubUsers
//
//  Created by Nik Cane on 05.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class Download {
  var resumeData: Data?
  var downloading: Bool = false
  var requestUrl: URL
  var task: URLSessionDataTask
  var finished: ((Result<URL, NetworkError>)->())?
  var request: RequestProtocol?
  var attempts: Int = 0
  
  init(requestUrl: URL,
       task: URLSessionDataTask) {
    self.requestUrl = requestUrl
    self.task = task
  }
  
  func repeatRequest() {
    self.task.cancel()
    self.task.resume()
  }
}
