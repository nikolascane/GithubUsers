//
//  UIViewController+Alert.swift
//  GithubUsers
//
//  Created by Nik Cane on 06.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

extension UIViewController {
  func presentError(_ error: NetworkError) {
    self.presentAlert(title: "Error", message: error.localizedDescription)
  }
  
  func presentAlert(title: String,
                    message: String,
                    confirmAction: (()->())? = nil,
                    style: UIAlertController.Style = .alert) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned alert] _ in
      alert.dismiss(animated: true, completion: nil)
    }))
    if let confirmAction = confirmAction {
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned alert] _ in
        confirmAction()
        alert.dismiss(animated: true, completion: nil)
      }))
    }
    self.present(alert, animated: true, completion: nil)
  }
}
