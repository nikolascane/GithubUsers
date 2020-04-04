//
//  UserCellTableViewCell.swift
//  GithubUsers
//
//  Created by Nik Cane on 04.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

  func configure(with user: User) {
    self.imageView?.image = nil
    self.textLabel?.text = user.nikname
    self.detailTextLabel?.text = user.name
  }
}
