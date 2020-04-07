//
//  UserRequest.swift
//  GithubUsers
//
//  Created by Nik Cane on 07.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

struct UserRequest: RequestProtocol {
  var timeout: TimeInterval = 30
  var method: RequestMethod = .GET
  var userName: String
  var queryItems: [String: String] {
    [:]
  }
  var host: HostType = .githubAPI
  var path: Paths {
    .user(self.userName)
  }
}
