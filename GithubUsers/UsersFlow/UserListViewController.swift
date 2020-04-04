//
//  MasterViewController.swift
//  GithubUsers
//
//  Created by Nik Cane on 03.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {

  private let cellId = "UserTableViewCellIdentifier"
  
  var viewModel: UserListProtocol = UserViewModel()
  var detailViewController: UserDetailsViewController? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureView()
    self.configureContent()
    self.startUIFlow()
  }
  
  private func configureView() {
    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? UserDetailsViewController
    }
  }
  
  private func configureContent() {
    
  }
  
  private func startUIFlow() {
    self.viewModel.getUsers {
      self.tableView.reloadData()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }
}
  // MARK: - Segues
extension UserListViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let controller = (segue.destination as? UINavigationController)?.topViewController as? UserDetailsViewController {
        controller.configureView(viewModel: self.viewModel as? UserDetailsProtocol)
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
        detailViewController = controller
      }
    }
  }
}
  // MARK: - Table View
extension UserListViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.users.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? UserTableViewCell {
      cell.configure(with: self.viewModel.users[indexPath.row])
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.viewModel.selectUser(at: indexPath)
  }
}

