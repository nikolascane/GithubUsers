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
  case avatarAPI = "avatars2.githubusercontent.com"
}

enum Paths {
  case users
  case user(String)
  case followers(userLogin: String)
  case avatar(userId: Int)
  
  var path: String {
    switch self {
    case .users:
      return "/users"
    case .user(let user):
      return "/users/\(user)"
    case .followers(let login):
      return "/\(login)/followers"
    case .avatar(let id):
      return "/u/\(id)"
    }
  }
}
