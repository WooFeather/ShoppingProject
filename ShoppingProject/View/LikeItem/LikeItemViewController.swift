//
//  LikeItemViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/4/25.
//

import UIKit

final class LikeItemViewController: UIViewController {

    private let likeItemView = LikeItemView()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureData()
    }
    
    // MARK: - Functions
    override func loadView() {
        view = likeItemView
    }
    
    // MARK: - Action
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension
// TODO: CollectionView에 좋아요 DB에 있는 데이터 보여주기
// TODO: 서치바에서 실시간 DB검색기능 구현

extension LikeItemViewController {
    private func configureView() {
        view.backgroundColor = .black
        navigationItem.title = "좋아요"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let chevron = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: chevron, style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureData() {
        likeItemView.accuracyButton.isSelected = true
        likeItemView.shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
    }
}
