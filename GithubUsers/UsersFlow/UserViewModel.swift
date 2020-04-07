//
//  UsersViewModel.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class UserViewModel {
  private let usersPerPage = 20
  private let initialUserId = 0
  
//MARK: UserDetailsProtocol
  var currentUser: User?
  var detailError: ((NetworkError)->())?
  
//MARK: UserListProtocol
  var users: [User] = []
  
  var avatarLoaded: ((IndexPath)->())?
  var error: ((NetworkError)->())?
}
 
extension UserViewModel: UserListProtocol {
 func getUsers(completion: @escaping ([IndexPath])->()) {
    UserListLoadWorker().perform(request: self.usersRequest()) { (result: Result<[User], NetworkError>) in
      DispatchQueue.main.async {
        switch result {
        case .success(let users):
          let countBefore = self.users.count
          let countAfter = countBefore + users.count
          self.users.append(contentsOf: users)
          
          let indexPaths = (countBefore..<countAfter).enumerated().map{
            IndexPath(row: $0.element, section: 0)
          }
          completion(indexPaths)
        case .failure(let error):
          self.error?(error)
        }
      }
    }
  }
  
  private func usersRequest() -> UserListRequest {
    if let user = self.users.last {
      return UserListRequest(lastUserId: user.id, usersPerPage: self.usersPerPage)
    }
    return UserListRequest(lastUserId: self.initialUserId, usersPerPage: self.usersPerPage)
  }
  
  func selectUser(at indexPath: IndexPath) {
    if indexPath.row < self.users.count {
      self.currentUser = self.users[indexPath.row]
    }
  }
  
  func loadAvatar(indexPath: IndexPath) {
    if self.needLoadAvatar(user: self.users[indexPath.row], large: false) {
      self.users[indexPath.row].smallAvatarDataloading = true
      self.loadAvatar(for: self.users[indexPath.row], large: false) { [weak self] url in
        guard let self = self else { return }
        self.users[indexPath.row].smallAvatarData = try? Data(contentsOf: url)
        self.users[indexPath.row].smallAvatarDataloading = false
        DispatchQueue.main.async {
          self.avatarLoaded?(indexPath)
        }
      }
    }
  }
}
 
extension UserViewModel: UserDetailsProtocol {
  
  func loadLargeAvatar(user: User, loaded: @escaping (URL)->()) {
    if needLoadAvatar(user: user, large: true) {
      user.largeAvatarDataLoading = true
      self.loadAvatar(for: user, large: true, success: { [weak user] url in
        user?.largeAvatarDataUrl = url
        user?.largeAvatarDataLoading = false
        DispatchQueue.main.async {
          loaded(url)
        }
      })
    }
  }
  
  func loadUser(name: String, loaded: @escaping (User)->()) {
    UserLoadWorker().perform(request: UserRequest(userName: name)) { (result: Result<User, NetworkError>) in
      DispatchQueue.main.async {
        switch result {
        case .success(let user):
          loaded(user)
        case .failure(let error):
          self.detailError?(error)
        }
      }
    }
  }
}
//MARK: Helpers
extension UserViewModel {
  private func loadAvatar(for user: User, large: Bool, success: @escaping (URL)->()) {
    let request = AvatarRequest(userId: user.id, large: large)
    AvatarLoadWorker().perform(request: request) { (result: Result<URL, NetworkError>) in
      switch result {
      case .success(let url):
        success(url)
      case .failure(let error):
        self.error?(error)
      }
    }
  }
  
  private func needLoadAvatar(user: User, large: Bool) -> Bool {
    let decisionBlock = { (avatarLoaded: Bool, avatarLoading: Bool) -> Bool in
      if avatarLoaded || avatarLoading {
        return false
      }
      return true
    }
    if large {
      return decisionBlock(user.largeAvatarDataUrl != nil, user.largeAvatarDataLoading == true)
    }
    return decisionBlock(user.smallAvatarData != nil, user.smallAvatarDataloading == true)
  }
}
