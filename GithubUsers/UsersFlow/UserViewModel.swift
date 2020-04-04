//
//  UsersViewModel.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class UserViewModel: UserListProtocol, UserDetailsProtocol {
  private let usersPerPage = 20
  private let initialUserId = 0
  
//MARK: UserDetailsProtocol
  var currentUser: User?
  
//MARK: UserListProtocol
  var users: [User] = []
  
  func getUsers(completion: ()->()) {
//    UsersLoadWorker
  }
  
  private func usersRequest() -> UsersRequest {
    if let user = self.users.last {
      return UsersRequest(lastUserId: user.id, usersPerPage: self.usersPerPage)
    }
    return UsersRequest(lastUserId: self.initialUserId, usersPerPage: self.usersPerPage)
  }
  
  func selectUser(at indexPath: IndexPath) {
    if indexPath.row < self.users.count {
      self.currentUser = self.users[indexPath.row]
    }
  }
}
