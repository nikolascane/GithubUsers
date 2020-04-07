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
  private let cellHeight: CGFloat = 60
  
  var viewModel: UserListProtocol = UserViewModel()

  @IBOutlet weak var activity: UIActivityIndicatorView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var scopeButton: UIBarButtonItem!
  
  private lazy var tapRecognizer: UITapGestureRecognizer = {
    var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
    return recognizer
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.configureContent()
    self.loadUsers()
  }

  private func configureContent() {
    self.title = "Github Users"
    self.viewModel.avatarLoaded = self.reloadCellAt
    self.scopeButton.target = self
    self.scopeButton.action = #selector(scopeChanged)
    self.setScopeButtonTitle()
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.addTarget(self, action: #selector(loadUsersFromScratch), for: .valueChanged)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.viewModel.error = self.presentError
    super.viewWillAppear(animated)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.viewModel.error = nil
    super.viewWillDisappear(animated)
  }
}
// MARK: - Table View
extension UserListViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    self.cellHeight
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.users.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? UserTableViewCell {
      cell.configure(with: self.viewModel.users[indexPath.row])
      DispatchQueue.global().async {
        self.viewModel.loadAvatar(indexPath: indexPath)
      }
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    self.viewModel.selectUser(at: indexPath)
    self.openDetails()
  }
}
//MARK: UIScrollViewDelegate
extension UserListViewController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let scrollHeigh = scrollView.frame.height
    if offsetY < 0 || contentHeight < self.cellHeight {
      return
    }
    if (offsetY + scrollHeigh >= contentHeight - self.cellHeight) {
      self.loadUsers()
    }
  }
}
//MARK: Actions
extension UserListViewController {
  
  @objc private func loadUsersFromScratch() {
    self.viewModel.disposeUsers()
    self.tableView.reloadData()
    self.loadUsers()
  }
  
  @objc private func loadUsers() {
    self.activity.startAnimating()
    self.viewModel.getUsers { [weak self] indexPaths in
      self?.activity.stopAnimating()
      self?.refreshControl?.endRefreshing()
      
      self?.tableView.beginUpdates()
      self?.tableView.insertRows(at: indexPaths, with: .automatic)
      self?.tableView.endUpdates()
    }
  }
  
  private func reloadCellAt(_ indexPath: IndexPath) {
    if let visiblePaths = self.tableView.indexPathsForVisibleRows, visiblePaths.contains(indexPath) {
      self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }
  
  private func openDetails() {
    if let detailsVC = UIStoryboard(name: Storyboards.main.rawValue, bundle: nil).instantiateViewController(withIdentifier: Controllers.details.rawValue) as? UserDetailsViewController {
      detailsVC.configureView(viewModel: self.viewModel as? UserDetailsProtocol)
      detailsVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
      detailsVC.navigationItem.leftItemsSupplementBackButton = true
      self.navigationController?.pushViewController(detailsVC, animated: true)
    }
  }
  
  @objc func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
  
  private func setScopeButtonTitle() {
    self.scopeButton.title = self.viewModel.searchScopeGlobal ? "Github" : "Local"
  }
  
  @objc func scopeChanged() {
    self.viewModel.searchScopeGlobal.toggle()
    self.setScopeButtonTitle()
  }
}
// MARK: - Search Bar Delegate
extension UserListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.dismissKeyboard()
    
    guard let searchText = searchBar.text, !searchText.isEmpty else {
      self.viewModel.disposeSearch()
      self.tableView.reloadData()
      return
    }
    
    self.activity.startAnimating()
    self.viewModel.searchUser(login: searchText, loaded: { [weak self] in
      self?.activity.stopAnimating()
      self?.tableView.reloadData()
    })
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.view.addGestureRecognizer(self.tapRecognizer)
    self.viewModel.prepareForSearch()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    self.view.removeGestureRecognizer(self.tapRecognizer)
  }
}
