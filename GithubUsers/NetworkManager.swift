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
  case timeout
  case serverIsUnavailable
  case pageNotFound
  case noData
  case parseError(String)
  
  var description: String {
    switch self {
    case .noConnection:
      return "Check your connection & try later"
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
    }
  }
}

class NetworkManager: NSObject {

  
  
}
