//
//  Endpoints.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import Foundation

enum HostType: String {
  case githubAPI = "api.github.com"
}

enum Paths {
  case users
  case followers(currentUser: String)
  
  var path: String {
    switch self {
    case .users:
      return "/users"
    case .followers(let currentUser):
      return "/\(currentUser)/followers"
    }
  }
}
