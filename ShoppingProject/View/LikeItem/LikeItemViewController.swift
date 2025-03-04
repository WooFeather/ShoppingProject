//
//  LikeItemViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/4/25.
//

import UIKit
import RealmSwift
import Toast

final class LikeItemViewController: UIViewController {

    private let realm = try! Realm()
    private let likeItemView = LikeItemView()
    private var likeItemList: Results<LikeItem>!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureData()
        fetchRealm()
    }
    
    // MARK: - Functions
    override func loadView() {
        view = likeItemView
    }
    
    private func fetchRealm() {
        print(realm.configuration.fileURL ?? "")
        
        likeItemList = realm.objects(LikeItem.self)
            .sorted(byKeyPath: "likeDate", ascending: false)
        
        likeItemView.resultCountLabel.text = "\(likeItemList.count)개의 상품"
    }
    
    // MARK: - Action
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func likeButtonTapped(_ sender: UIButton) {
        let data = likeItemList[sender.tag]
        var style = ToastStyle()
        style.backgroundColor = .white
        style.messageColor = .black
        
        do {
            try realm.write {
                realm.delete(data)
                view.makeToast("좋아요 취소되었습니다.", duration: 1.0, position: .center, style: style)
                likeItemView.resultCountLabel.text = "\(likeItemList.count)개의 상품"
                
                likeItemView.shoppingCollectionView.reloadData()
            }
        } catch {
            print("렘 데이터 삭제 실패")
        }
    }
}

// MARK: - Extension
extension LikeItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.id, for: indexPath) as? ShoppingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = likeItemList[indexPath.item]
        cell.likeButton.tag = indexPath.item
        
        cell.configureRealmData(data: data)
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        return cell
    }
}

extension LikeItemViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.isEmpty {
            fetchRealm()
            likeItemView.shoppingCollectionView.reloadData()
        } else {
            likeItemList = realm.objects(LikeItem.self)
                .sorted(byKeyPath: "likeDate", ascending: false)
                .where { $0.titleName.contains(searchText, options: .caseInsensitive) }
            
            likeItemView.resultCountLabel.text = "\(likeItemList.count)개의 상품"
            likeItemView.shoppingCollectionView.reloadData()
        }
    }
}

extension LikeItemViewController {
    private func configureView() {
        view.backgroundColor = .black
        navigationItem.title = "좋아요한 상품"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let chevron = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: chevron, style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureData() {
        likeItemView.shoppingCollectionView.delegate = self
        likeItemView.shoppingCollectionView.dataSource = self
        likeItemView.itemSearchBar.delegate = self
        likeItemView.accuracyButton.isSelected = true
        likeItemView.shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
    }
}
