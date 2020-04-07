//
//  UserFlowProtocols.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import Foundation

protocol UserListProtocol {
  var users: [User] {get}
  var avatarLoaded: ((IndexPath)->())? {get set}
  var error: ((NetworkError)->())? {get set}
  
  func getUsers(completion:  @escaping ([IndexPath])->())
  func selectUser(at indexPath: IndexPath)
  func loadAvatar(indexPath: IndexPath)
}

protocol UserDetailsProtocol {
  var currentUser: User? {get set}
  var detailError: ((NetworkError)->())? {get set}
  
  func loadUser(name: String, loaded: @escaping (User)->())
  func loadLargeAvatar(user: User, loaded: @escaping (URL)->())
}
