//
//  LikeItemViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/4/25.
//

import UIKit
import RealmSwift

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
        
        cell.configureRealmData(data: data)
        return cell
    }
}

// TODO: 서치바에서 실시간 DB검색기능 구현

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
        likeItemView.accuracyButton.isSelected = true
        likeItemView.shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
    }
}
