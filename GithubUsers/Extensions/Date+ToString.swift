//
//  Date+ToString.swift
//  GithubUsers
//
//  Created by Nik Cane on 07.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

extension Date {
  func toString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YY.MM.dd"
    return formatter.string(from: self)
  }
}
