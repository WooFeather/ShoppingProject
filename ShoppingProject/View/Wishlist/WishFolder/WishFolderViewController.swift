//
//  WishFolderViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/5/25.
//

import UIKit

final class WishFolderViewController: UIViewController {
    private let wishFolderView = WishFolderView()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureData()
    }
    
    // MARK: - Functions
    override func loadView() {
        view = wishFolderView
    }
    
    // MARK: - Actions
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension
extension WishFolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.id, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "텍스트"
        content.textProperties.color = .white
        content.secondaryText = "아아아"
        content.secondaryTextProperties.color = .lightGray
        
        cell.contentConfiguration = content
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        
        return cell
    }
}

extension WishFolderViewController {
    private func configureView() {
        view.backgroundColor = .black
        navigationItem.title = "위시리스트"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let chevron = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: chevron, style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureData() {
        wishFolderView.folderTableView.delegate = self
        wishFolderView.folderTableView.dataSource = self
        wishFolderView.folderTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.id)
    }
}
