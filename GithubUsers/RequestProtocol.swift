//
//  NetworkProtocols.swift
//  GithubUsers
//
//  Created by Nik Cane on 03.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import Foundation

enum RequestMethod: String {
  case GET
  case POST
}

protocol RequestProtocol {
  var timeout: TimeInterval {get set}
  var method: RequestMethod {get set}
  var queryItems: [String: String] {get}
  var host: HostType {get}
  var path: Paths {get}
  var url: URL? {get}
}

extension RequestProtocol {
  
  var url: URL? { self.urlComponents.url }
  
  private var urlComponents: URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = self.host.rawValue
    components.path = self.path.path
    components.setQueryItems(with: self.queryItems)
    return components
  }
}





