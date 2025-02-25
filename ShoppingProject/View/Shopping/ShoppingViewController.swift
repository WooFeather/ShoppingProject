//
//  ShoppingViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ShoppingViewController: UIViewController {
    
    // TODO: 추후 삭제
    // let bfViewModel = BFShoppingViewModel()
    
    private let shoppingView = ShoppingView()
    private let disposeBag = DisposeBag()
    let viewModel = ShoppingViewModel()
    
    // MARK: - LifeCycle
    override func loadView() {
        view = shoppingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        //        bindData()
        //        configureAction()
        configureView()
        configureData()
    }
    
    // MARK: - Functions
    
    private func bind() {
        let input = ShoppingViewModel.Input()
        let output = viewModel.transfer(input: input)
        
        output.queryText
            .bind(with: self) { owner, text in
                owner.navigationItem.title = text
            }
            .disposed(by: disposeBag)
    }
    
//    private func bindData() {
//        bfViewModel.inputViewDidLoadTrigger.value = ()
//        
//        bfViewModel.outputSearchText.bind { text in
//            self.navigationItem.title = text
//        }
//        
//        bfViewModel.outputSearchItem.lazyBind { _ in
//            self.shoppingView.shoppingCollectionView.reloadData()
//        }
//        
//        bfViewModel.outputCountText.lazyBind { count in
//            self.shoppingView.resultCountLabel.text = count
//        }
//        
//        bfViewModel.outputItemIsEmpty.lazyBind { state in
//            // 검색결과가 0개일 경우 scrollToItem을 하면 앱이 터질 수 있어서 조건처리
//            if !state {
//                self.shoppingView.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
//            } else {
//                return
//            }
//        }
//        
//        bfViewModel.outputBackButtonTapped.lazyBind { _ in
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
    
//    private func configureAction() {
//        shoppingView.accuracyButton.addTarget(self, action: #selector(accuracyButtonTapped), for: .touchUpInside)
//        shoppingView.dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
//        shoppingView.highPriceButton.addTarget(self, action: #selector(highPriceButtonTapped), for: .touchUpInside)
//        shoppingView.lowPriceButton.addTarget(self, action: #selector(lowPriceButtonTapped), for: .touchUpInside)
//    }
    
    // MARK: - Actions
//    @objc
//    private func accuracyButtonTapped() {
//        print(#function)
//        shoppingView.accuracyButton.isSelected = true
//        [shoppingView.dateButton, shoppingView.highPriceButton, shoppingView.lowPriceButton].forEach {
//            $0.isSelected = false
//        }
//        
//        bfViewModel.inputAccuracyButtonTapped.value = ()
//    }
//    
//    @objc
//    private func dateButtonTapped() {
//        print(#function)
//        shoppingView.dateButton.isSelected = true
//        [shoppingView.accuracyButton, shoppingView.highPriceButton, shoppingView.lowPriceButton].forEach {
//            $0.isSelected = false
//        }
//        
//        bfViewModel.inputDateButtonTapped.value = ()
//    }
//    
//    @objc
//    private func highPriceButtonTapped() {
//        print(#function)
//        shoppingView.highPriceButton.isSelected = true
//        
//        [shoppingView.accuracyButton, shoppingView.dateButton, shoppingView.lowPriceButton].forEach {
//            $0.isSelected = false
//        }
//        
//        bfViewModel.inputHighPriceButtonTapped.value = ()
//    }
//    
//    @objc
//    private func lowPriceButtonTapped() {
//        print(#function)
//        shoppingView.lowPriceButton.isSelected = true
//        [shoppingView.accuracyButton, shoppingView.dateButton, shoppingView.highPriceButton].forEach {
//            $0.isSelected = false
//        }
//        
//        bfViewModel.inputLowPriceButtonTapped.value = ()
//    }
//    
    @objc
    private func backButtonTapped() {
        // bfViewModel.inputBackButtonTapped.value = ()
        navigationController?.popViewController(animated: true)
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

//extension ShoppingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return bfViewModel.outputSearchItem.value.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = shoppingView.shoppingCollectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.id, for: indexPath) as? ShoppingCollectionViewCell else { return UICollectionViewCell() }
//        
//        let data = bfViewModel.outputSearchItem.value[indexPath.row]
//        cell.configureData(data: data)
//        
//        return cell
//    }
//}

// MARK: - ConfigureView
extension ShoppingViewController {
    private func configureView() {
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let chevron = UIImage(systemName: "chevron.left")
        // let backButton = UIBarButtonItem(image: chevron)
         let backButton = (UIBarButtonItem(image: chevron, style: .plain, target: self, action: #selector(backButtonTapped)))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureData() {
        shoppingView.accuracyButton.isSelected = true
//        shoppingView.shoppingCollectionView.delegate = self
//        shoppingView.shoppingCollectionView.dataSource = self
        // shoppingView.shoppingCollectionView.prefetchDataSource = self
        shoppingView.shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
    }
}
