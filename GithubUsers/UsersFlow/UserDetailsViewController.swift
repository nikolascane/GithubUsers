//
//  DetailViewController.swift
//  GithubUsers
//
//  Created by Nik Cane on 03.04.2020.
//  Copyright © 2020 Nik Cane. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var repos: UILabel!
  @IBOutlet weak var gists: UILabel!
  @IBOutlet weak var followers: UILabel!
  @IBOutlet weak var following: UILabel!
  @IBOutlet weak var company: UILabel!
  @IBOutlet weak var createdAt: UILabel!
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var blogButton: UIButton!
  
  @IBOutlet weak var activity: UIActivityIndicatorView!
  
  private var viewModel: UserDetailsProtocol?
  private var currentUser: User?
  
  private let userDispatchGroup = DispatchGroup()

  func configureView(viewModel: UserDetailsProtocol?) {
    self.viewModel = viewModel
    self.viewModel?.detailError = self.presentError
  }
  
  private func setupContent() {
    self.title = self.viewModel?.currentUser?.nikname
    self.name.text = viewModel?.currentUser?.name ?? "No Name"
    self.repos.text = "Repos: \(viewModel?.currentUser?.publicRepos ?? 0)"
    self.gists.text = "Gists: \(viewModel?.currentUser?.publicGists ?? 0)"
    self.followers.text = "Followers: \(viewModel?.currentUser?.followers ?? 0)"
    self.following.text = "Following: \(viewModel?.currentUser?.following ?? 0)"
    self.company.text = "\(viewModel?.currentUser?.company ?? "Unemployed")"
    let createdAt = viewModel?.currentUser?.createdAt?.toString() ?? "beginning"
    self.createdAt.text = "Profile from: \(createdAt)"
    if let email = viewModel?.currentUser?.email {
      self.emailButton.alpha = 1.0
      self.emailButton.setTitle(email, for: .normal)
    }
    if let blog = viewModel?.currentUser?.blog {
      self.blogButton.alpha = 1.0
      self.blogButton.setTitle(blog, for: .normal)
    }
  }
  
  private func drawImage() {
    if let url = self.viewModel?.currentUser?.largeAvatarDataUrl, let data = try? Data(contentsOf: url) {
      self.userImageView.image = UIImage(data: data)
    }
    else {
      self.userImageView.image = UIImage(named: "defaultAvatar")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.activity.startAnimating()
    self.loadAvatar()
    self.loadUserDetails()
    self.setupContent()
    self.drawImage()
    self.setupDispatchGroup()
  }
  
  private func setupDispatchGroup() {
    self.userDispatchGroup.notify(queue: .main) { [weak self] in
      self?.activity.stopAnimating()
      self?.currentUser?.largeAvatarDataUrl = self?.viewModel?.currentUser?.largeAvatarDataUrl
      self?.viewModel?.currentUser = self?.currentUser
      self?.setupContent()
      self?.drawImage()
    }
  }
}
//  MARK: Actions
extension UserDetailsViewController {
  private func loadUserDetails() {
    self.userDispatchGroup.enter()
    if let name = self.viewModel?.currentUser?.nikname {
      self.viewModel?.loadUser(name: name, loaded: { [weak self] user in
        self?.currentUser = user
        self?.userDispatchGroup.leave()
      })
    }
  }
  
  private func loadAvatar() {
    self.userDispatchGroup.enter()
    if let user = self.viewModel?.currentUser {
      self.viewModel?.loadLargeAvatar(user:
        user, loaded: { [weak self] url in
          self?.viewModel?.currentUser?.largeAvatarDataUrl = url
          self?.userDispatchGroup.leave()
      })
    }
  }
  
  @IBAction func emailButtonDidTap(_ sender: Any) {
  }
  @IBAction func blogButtonDidTap(_ sender: Any) {
    if let blog = self.viewModel?.currentUser?.blog, let url = URL(string: blog), UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
  
}

