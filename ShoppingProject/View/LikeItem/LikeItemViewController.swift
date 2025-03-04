//
//  LikeItemViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/4/25.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Toast

final class LikeItemViewController: UIViewController {

    private let realm = try! Realm()
    private let likeItemView = LikeItemView()
    private let viewModel = LikeItemViewModel()
    private var likeItemList: Results<LikeItem>!
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureData()
        // bind()
        fetchRealm()
    }
    
    // MARK: - Functions
    override func loadView() {
        view = likeItemView
    }
    
    // cell 안에 좋아요 버튼 로직때문에 실패 ㅜ ㅜ
//    private func bind() {
//        let input = LikeItemViewModel.Input(
//            viewWillAppear: rx.viewWillAppear,
//            searchTextChanged: likeItemView.itemSearchBar.rx.text.orEmpty,
//            backButtonTapped: navigationItem.leftBarButtonItem?.rx.tap
//        )
//        let output = viewModel.transfer(input: input)
//        
//        output.likeItemList
//            .drive(likeItemView.shoppingCollectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.id, cellType: ShoppingCollectionViewCell.self)) { item, element, cell in
//                cell.configureRealmData(data: element)
//                cell.likeButton.rx.tap
//                    .asDriver()
//                    .drive(with: self) { owner, _ in
//                        // 어떻게 배열에 접근하지???????????????????
//                        let data = ??????
//                        var style = ToastStyle()
//                        style.backgroundColor = .white
//                        style.messageColor = .black
//                        
//                        do {
//                            try owner.realm.write {
//                                owner.realm.delete(data)
//                                owner.view.makeToast("좋아요 취소되었습니다.", duration: 1.0, position: .center, style: style)
//                                
//                                owner.likeItemView.shoppingCollectionView.reloadData()
//                            }
//                        } catch {
//                            print("렘 데이터 삭제 실패")
//                        }
//                    }
//                    .disposed(by: cell.disposBag)
//            }
//            .disposed(by: disposeBag)
//        
//        output.likeListCount
//            .drive(with: self) { owner, count in
//                owner.likeItemView.resultCountLabel.text = "\(count.formatted())개의 상품"
//            }
//            .disposed(by: disposeBag)
//        
//        output.backButtonTapped?
//            .drive(with: self) { owner, _ in
//                owner.navigationController?.popViewController(animated: true)
//            }
//            .disposed(by: disposeBag)
//    }
    
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
