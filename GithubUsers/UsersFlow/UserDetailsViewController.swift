//
//  DetailViewController.swift
//  GithubUsers
//
//  Created by Nik Cane on 03.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

  @IBOutlet weak var detailDescriptionLabel: UILabel!
  
  var viewModel: UserDetailsProtocol?

  func configureView(viewModel: UserDetailsProtocol?) {
    self.viewModel = viewModel
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  
  }

}

