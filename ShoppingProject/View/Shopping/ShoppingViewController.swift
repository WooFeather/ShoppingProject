//
//  ShoppingViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

final class ShoppingViewController: UIViewController {
    
    private let realm = try! Realm()
    private let shoppingView = ShoppingView()
    private let disposeBag = DisposeBag()
    let viewModel = ShoppingViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureData()
        bind()
    }
    
    // MARK: - Functions
    
    override func loadView() {
        view = shoppingView
    }
    
    private func bind() {
        let input = ShoppingViewModel.Input(
            accuracyButtonTapped: shoppingView.accuracyButton.rx.tap,
            dateButtonTapped: shoppingView.dateButton.rx.tap,
            highPriceButtonTapped: shoppingView.highPriceButton.rx.tap,
            lowPriceButtonTapped: shoppingView.lowPriceButton.rx.tap,
            backButtonTapped: navigationItem.leftBarButtonItem?.rx.tap
        )
        let output = viewModel.transfer(input: input)
        
        output.queryText
            .drive(with: self) { owner, text in
                owner.navigationItem.title = text
            }
            .disposed(by: disposeBag)
        
        output.totalCountText
            .drive(with: self) { owner, value in
                owner.shoppingView.resultCountLabel.text = value
            }
            .disposed(by: disposeBag)
        
        output.searchList
            .drive(shoppingView.shoppingCollectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.id, cellType: ShoppingCollectionViewCell.self)) { (item, element, cell) in
                
                cell.configureData(data: element)
                cell.likeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        cell.likeButton.isSelected.toggle()
                        print(cell.likeButton.isSelected, item)
                        // realm에 저장
                        if cell.likeButton.isSelected {
                            do {
                                try owner.realm.write {
                                    let data = LikeItem(imageURL: element.image, mallName: element.mallName, titleName: element.title, price: element.price)
                                    
                                    owner.realm.add(data)
                                    print("렘 저장 완료")
                                }
                            } catch {
                                print("렘 저장 실패")
                            }
                        } else {
                            // TODO: realm에서 삭제
                        }
                    }
                    .disposed(by: cell.disposBag)
            }
            .disposed(by: disposeBag)
        
        // 검색결과가 없는 경우가 아니라면 필터링했을 때 뷰를 맨 위로 올리기
        output.isItemEmpty
            .drive(with: self) { owner, isEmpty in
                if !isEmpty {
                    owner.shoppingView.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                } else {
                    owner.showAlert(title: "검색 결과가 없어요😭", message: "검색 결과가 없습니다. 검색어를 다시 확인해주세요.", button: "확인") {
                        owner.navigationController?.popViewController(animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        Driver.combineLatest(output.accuracyIsSelected, output.dateIsSelected, output.highPriceIsSelected, output.lowPriceIsSelected)
            .drive(with: self) { owner, value in
                owner.shoppingView.accuracyButton.isSelected = value.0
                owner.shoppingView.dateButton.isSelected = value.1
                owner.shoppingView.highPriceButton.isSelected = value.2
                owner.shoppingView.lowPriceButton.isSelected = value.3
            }
            .disposed(by: disposeBag)
        
        output.backButtonTapped?
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.errorAlert
            .drive(with: self) { owner, value in
                owner.showAlert(title: value.title, message: value.message, button: "확인") {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Extension
// 페이지네이션 기능 주석처리
//extension ShoppingViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("🔗indexPath야 \(indexPaths)")
//        
//        // max값을 구해서 분기처리 (10만보다 많으면 맥스값은 10만, 적으면 그 불러온 아이템수 값
//        for item in indexPaths {
//            if list.count - 3 == item.item {
//                if list.count < maxNum {
//                    start += 1
//                    callRequest(query: viewModel.outputSearchText.value ?? "")
//                } else {
//                    print("❗️마지막 페이지야!!")
//                }
//            }
//        }
//    }
//}

// MARK: - ConfigureView
extension ShoppingViewController {
    private func configureView() {
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let chevron = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: chevron)
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureData() {
        shoppingView.accuracyButton.isSelected = true
        shoppingView.shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
    }
}
