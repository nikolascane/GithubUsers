//
//  UserCellTableViewCell.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageView?.image = nil
    self.textLabel?.text = nil
  }
  
  func configure(with user: User) {
    if let data = user.smallAvatarData {
      self.imageView?.image = UIImage(data: data)
    }
    else {
      self.imageView?.image = UIImage(named: "defaultAvatar")
    }
    self.textLabel?.text = user.nikname
  }
}
