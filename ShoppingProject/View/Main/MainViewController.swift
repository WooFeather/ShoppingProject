//
//  MainViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    // MARK: - Functions
    
    override func loadView() {
        view = mainView
    }
    
    private func bind() {
        let input = MainViewModel.Input(
            searchButtonTapped: mainView.shoppingSearchBar.rx.searchButtonClicked,
            searchText: mainView.shoppingSearchBar.rx.text.orEmpty,
            wishlistButtonTapped: navigationItem.rightBarButtonItem?.rx.tap
        )
        let output = viewModel.transfer(input: input)
        
        Driver.zip(output.isTextValidate, output.queryText)
            .drive(with: self) { owner, value in
                if value.0 {
                    print(value.1)
                    let vc = ShoppingViewController()
                    vc.viewModel.queryText.accept(value.1)
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    print(value.1)
                    owner.showAlert(title: "검색어를 다시 확인해주세요😭", message: "검색어는 2글자 이상이어야 합니다.", button: "확인") {
                        owner.dismiss(animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.wishlistButtonTapped?
            .drive(with: self) { owner, _ in
                let vc = WishlistViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ConfigureView
extension MainViewController {
    private func configureView() {
        navigationItem.title = "도봉러의 쇼핑쇼핑"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let wishlistButton = UIBarButtonItem(image: UIImage(systemName: "heart.square.fill"))
        navigationItem.rightBarButtonItem = wishlistButton
        navigationController?.navigationBar.tintColor = .white
    }
}


