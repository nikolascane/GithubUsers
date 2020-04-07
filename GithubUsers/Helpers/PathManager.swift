//
//  PathManager.swift
//  GithubUsers
//
//  Created by Nik Cane on 05.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class PathManager {
  class func directory() -> URL? {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }

  class func namedDirectory(for url: URL, ext: String) -> URL? {
    self.directory()?.appendingPathComponent(url.lastPathComponent + "." + ext)
  }
  
  class func removeAt(_ url: URL) throws{
    try FileManager.default.removeItem(at: url)
  }
  
  class func copyItem(from source: URL, to destination: URL) throws {
    try FileManager.default.copyItem(at: source, to: destination)
  }
}
