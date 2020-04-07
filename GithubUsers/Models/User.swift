//
//  User.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit
import Foundation

class User: Decodable {
  let nikname: String
  let name: String?
  let id: Int
  let avatarUrl: String
  let page: String
  let followersList: String
  let type: String
  let admin: Bool
  let company: String?
  let blog: String?
  let location: String?
  let email: String?
  let publicRepos: Int?
  let publicGists: Int?
  let followers: Int?
  let following: Int?
  let createdAt: Date?
  var smallAvatarData: Data?
  var smallAvatarDataloading: Bool = false
  var largeAvatarDataUrl: URL?
  var largeAvatarDataLoading: Bool = false
  
  private enum CodingKeys: String, CodingKey {
    case nikname = "login"
    case name = "name"
    case id = "id"
    case avatarUrl = "avatar_url"
    case page = "html_url"
    case followersList = "followers_url"
    case type = "type"
    case admin = "site_admin"
    case company = "company"
    case blog = "blog"
    case location = "location"
    case email = "email"
    case publicRepos = "public_repos"
    case publicGists = "public_gists"
    case followers = "followers"
    case following = "following"
    case createdAt = "created_at"
  }
  
  init(decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.nikname = try container.decode(String.self, forKey: .nikname)
    self.id = try container.decode(Int.self, forKey: .id)
    self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
    self.page = try container.decode(String.self, forKey: .page)
    self.followersList = try container.decode(String.self, forKey: .followersList)
    self.type = try container.decode(String.self, forKey: .type)
    self.admin = try container.decode(Bool.self, forKey: .admin)
    self.company = try container.decode(String.self, forKey: .company)
    self.blog = try container.decode(String.self, forKey: .blog)
    self.location = try container.decode(String.self, forKey: .location)
    self.email = try container.decode(String.self, forKey: .email)
    self.publicRepos = try container.decode(Int.self, forKey: .publicRepos)
    self.publicGists = try container.decode(Int.self, forKey: .publicGists)
    self.followers = try container.decode(Int.self, forKey: .followers)
    self.following = try container.decode(Int.self, forKey: .followersList)
    self.createdAt = try container.decode(Date.self, forKey: .createdAt)
  }
}
