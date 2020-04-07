//
//  UserLoadWorker.swift
//  GithubUsers
//
//  Created by Nik Cane on 03.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class UserListLoadWorker {
  func perform(request: UserListRequest, resultCompletion: @escaping (Result<[User], NetworkError>)->()) {
    NetworkManager.shared.performRequest(request) { (result: Result<URL, NetworkError>) in
      switch result {
      case .success(let url):
        if let data = try? Data(contentsOf: url) {
          resultCompletion(self.objectFrom(data: data))
        }
      case .failure(let error):
        resultCompletion(Result.failure(error))
      }
    }
  }
  
  private func objectFrom(data: Data) -> Result<[User], NetworkError> {
    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let users = try decoder.decode([User].self, from: data)
      return Result.success(users)
    }
    catch let error {
      return Result.failure(NetworkError.parseError(error.localizedDescription))
    }
  }
}
