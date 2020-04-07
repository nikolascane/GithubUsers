//
//  UsersRequest.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

struct UserListRequest: RequestProtocol {
  var timeout: TimeInterval = 30
  var method: RequestMethod = .GET
  var lastUserId: Int
  var usersPerPage: Int
  var queryItems: [String: String] {
    ["since": "\(lastUserId)", "per_page": "\(usersPerPage)"]
  }
  var host: HostType = .githubAPI
  var path: Paths = .users
}

