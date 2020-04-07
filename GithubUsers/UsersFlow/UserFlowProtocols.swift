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
  var searchScopeGlobal: Bool {get set}
  
  func getUsers(completion:  @escaping ([IndexPath])->())
  func disposeUsers()
  func selectUser(at indexPath: IndexPath)
  func loadAvatar(indexPath: IndexPath)
  func searchUser(login: String, loaded: @escaping ()->())
  func prepareForSearch()
  func disposeSearch()
}

protocol UserDetailsProtocol {
  var currentUser: User? {get set}
  var error: ((NetworkError)->())? {get set}
  
  func loadUser(name: String, loaded: @escaping (User)->())
  func loadLargeAvatar(user: User, loaded: @escaping (URL)->())
}
