//
//  WishFolderViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/5/25.
//

import UIKit
import RealmSwift

final class WishFolderViewController: UIViewController {
    private let wishFolderView = WishFolderView()
    private var folderList: Results<WishFolder>!
    private let repository: WishFolderRepository = WishFolderTableRepository()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureData()
        
        folderList = repository.fetchAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wishFolderView.folderTableView.reloadData()
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
    
    @objc
    private func addButtonTapped() {
        repository.createItem(name: "개인")
        repository.createItem(name: "업무")
        repository.createItem(name: "생필품")
        repository.createItem(name: "언젠간..")
        
        wishFolderView.folderTableView.reloadData()
    }
}

// MARK: - Extension
extension WishFolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.id, for: indexPath)
        let data = folderList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = data.name
        content.secondaryText = "\(data.wishlist.count)개"
        content.textProperties.color = .white
        content.secondaryTextProperties.color = .lightGray
        
        cell.contentConfiguration = content
        cell.backgroundColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = folderList[indexPath.row]
        let vc = WishlistViewController()
        vc.wishlistList = Array(data.wishlist)
        vc.folderNameContents = data.name
        vc.idContents = data.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WishFolderViewController {
    private func configureView() {
        view.backgroundColor = .black
        navigationItem.title = "위시리스트"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let chevron = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: chevron, style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        let plus = UIImage(systemName: "plus")
        let addButton = UIBarButtonItem(image: plus, style: .done, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureData() {
        wishFolderView.folderTableView.delegate = self
        wishFolderView.folderTableView.dataSource = self
        wishFolderView.folderTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.id)
    }
}
