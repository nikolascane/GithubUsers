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
  
  func getUsers(completion: ()->())
  func selectUser(at indexPath: IndexPath)
}

protocol UserDetailsProtocol {
  var currentUser: User? {get}
}
