//
//  User.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit
import Foundation

struct User: Decodable {
  let nikname: String
  let name: String?
  let id: Int
  let avatarUrl: String
  let page: String
  let followersList: String
  let type: String
  let admin: Bool
  let company: String?
  let blog: String
  let location: String
  let email: String?
  let publicRepos: Int
  let publicGists: Int
  let followers: Int
  let following: Int
  let createdAt: String
  //nikname "login": "mojombo",
  // "id": 1,
  //avatarUrl "avatar_url": "https://avatars0.githubusercontent.com/u/1?v=4&s=60",
  //page "html_url": "https://github.com/mojombo",
  //followersList "followers_url": "https://api.github.com/users/mojombo/followers",
  //type "type": "User",
  //admin "site_admin": false,
  //name "name": "Tom Preston-Werner",
  //company "company": null,
  //blog "blog": "http://tom.preston-werner.com",
  //location "location": "San Francisco",
  //email "email": null,
  //publicRepos "public_repos": 61,
  //publicGists "public_gists": 62,
  //followers "followers": 21896,
  //following "following": 11,
  //createsAt "created_at": "2007-10-20T05:24:19Z",
  
  private enum CodingKeys: String, CodingKey {
    case nikname = "login"
    case name
    case id
    case avatarUrl = "avatar_url"
    case page = "html_url"
    case followersList = "followers_url"
    case type
    case admin = "site_admin"
    case company
    case blog
    case location
    case email
    case publicRepos = "public_repos"
    case publicGists = "public_gists"
    case followers
    case following
    case createdAt = "created_at"
  }
  
//  required init(decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: UserCodingKeys.self)
//    self.
//  }
}
