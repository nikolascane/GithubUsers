//
//  AvatarLoadWorker.swift
//  GithubUsers
//
//  Created by Nik Cane on 03.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class AvatarLoadWorker {
  func perform(request: AvatarRequest, resultCompletion: @escaping (Result<URL, NetworkError>)->()) {
    NetworkManager.shared.performRequest(request, responseCompletion: resultCompletion)
  }
}
