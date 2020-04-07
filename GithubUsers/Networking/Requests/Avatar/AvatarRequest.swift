//
//  AvatarRequest.swift
//  GithubUsers
//
//  Created by Nik Cane on 06.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

struct AvatarRequest: RequestProtocol {
  var timeout: TimeInterval = 30
  var method: RequestMethod = .GET
  var userId: Int
  var large: Bool
  var queryItems: [String: String] {
    ["v": "4", "s": large ? "300" : "60"]
  }
  var host: HostType = .avatarAPI
  var path: Paths {
    .avatar(userId: userId)
  }
}
