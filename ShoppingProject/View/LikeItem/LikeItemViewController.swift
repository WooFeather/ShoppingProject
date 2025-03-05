//
//  LikeItemViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/4/25.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class LikeItemViewController: UIViewController {

    private let likeItemView = LikeItemView()
    private let viewModel = LikeItemViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureData()
//        fetchData()
        bind()
    }
    
    // MARK: - Functions
    override func loadView() {
        view = likeItemView
    }
    
    // cell 안에 좋아요 버튼 로직때문에 실패 ㅜ ㅜ => 성공했지롱 ㅎ_ㅎ
    private func bind() {
        let input = LikeItemViewModel.Input(
            viewWillAppear: rx.viewWillAppear,
            searchTextChanged: likeItemView.itemSearchBar.rx.text.orEmpty,
            backButtonTapped: navigationItem.leftBarButtonItem?.rx.tap
        )
        let output = viewModel.transfer(input: input)
        
        output.likeItemList
            .drive(likeItemView.shoppingCollectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.id, cellType: ShoppingCollectionViewCell.self)) { item, element, cell in
                cell.configureRealmData(data: element)
                cell.likeButton.rx.tap
                    .asDriver()
                    .drive(with: self) { owner, _ in
                        owner.viewModel.likeButtonTapped?(item) // 클로저 실행
                        
                        var style = ToastStyle()
                        style.backgroundColor = .white
                        style.messageColor = .black
                        
                        owner.view.makeToast("좋아요 취소되었습니다.", duration: 1.0, position: .center, style: style)
                        
                        owner.likeItemView.shoppingCollectionView.reloadData()
                    }
                    .disposed(by: cell.disposBag)
            }
            .disposed(by: disposeBag)
        
        output.likeListCount
            .drive(with: self) { owner, count in
                owner.likeItemView.resultCountLabel.text = "\(count.formatted())개의 상품"
            }
            .disposed(by: disposeBag)
        
        output.backButtonTapped?
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
//    private func fetchData() {
//        likeItemList = repository.fetchAll()
//        likeItemView.resultCountLabel.text = "\(likeItemList.count)개의 상품"
//    }
    
    // MARK: - Action
//    @objc
//    private func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc
//    private func likeButtonTapped(_ sender: UIButton) {
//        let data = likeItemList[sender.tag]
//        var style = ToastStyle()
//        style.backgroundColor = .white
//        style.messageColor = .black
//        
//        repository.deleteItem(data: data)
//        
//        view.makeToast("좋아요 취소되었습니다.", duration: 1.0, position: .center, style: style)
//        likeItemView.resultCountLabel.text = "\(likeItemList.count)개의 상품"
//        
//        likeItemView.shoppingCollectionView.reloadData()
//    }
}

// MARK: - Extension
//extension LikeItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return likeItemList.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.id, for: indexPath) as? ShoppingCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        
//        let data = likeItemList[indexPath.item]
//        cell.likeButton.tag = indexPath.item
//        
//        cell.configureRealmData(data: data)
//        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
//        
//        return cell
//    }
//}

//extension LikeItemViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//        if searchText.isEmpty {
//            likeItemList = repository.fetchAll()
//            likeItemView.shoppingCollectionView.reloadData()
//        } else {
//            likeItemList = repository.fetchFilteredItem(text: searchText)
//            likeItemView.resultCountLabel.text = "\(likeItemList.count)개의 상품"
//            likeItemView.shoppingCollectionView.reloadData()
//        }
//    }
//}

extension LikeItemViewController {
    private func configureView() {
        view.backgroundColor = .black
        navigationItem.title = "좋아요한 상품"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let chevron = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: chevron)
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureData() {
//        likeItemView.shoppingCollectionView.delegate = self
//        likeItemView.shoppingCollectionView.dataSource = self
//        likeItemView.itemSearchBar.delegate = self
        likeItemView.accuracyButton.isSelected = true
        likeItemView.shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
    }
}
