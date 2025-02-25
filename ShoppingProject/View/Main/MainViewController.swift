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
    
    // TODO: 추후 삭제예정
    // private let bfviewModel = BFMainViewModel()
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
//        bindData()
        configureEssential()
    }
    
    // MARK: - Functions
    
    private func bind() {
        let input = MainViewModel.Input(
            searchButtonTapped: mainView.shoppingSearchBar.rx.searchButtonClicked,
            searchText: mainView.shoppingSearchBar.rx.text.orEmpty
        )
        let output = viewModel.transfer(input: input)
        
        Observable.combineLatest(output.isTextValidate, output.queryText)
            .bind(with: self) { owner, value in
                if value.0 {
                    print(value.1)
                    let vc = ShoppingViewController()
                    vc.viewModel.queryText.accept(value.1)
                    owner.navigationController?.pushViewController(vc, animated: true)
                } else {
                    owner.showAlert(title: "검색어를 다시 확인해주세요😭", message: "검색어는 2글자 이상이어야 합니다.", button: "확인") {
                        owner.dismiss(animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    //    private func bindData() {
    //        bfviewModel.outputSearchButtonTapped.lazyBind { data in
    //            let vc = ShoppingViewController()
    //            vc.bfViewModel.outputSearchText.value = data
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //
    //        bfviewModel.outputValidateAlert.bind { state in
    //            if state {
    //                self.showAlert(title: "검색어를 다시 확인해주세요😭", message: "검색어는 2글자 이상이어야 합니다.", button: "확인") {
    //                    self.dismiss(animated: true)
    //                }
    //            } else {
    //                return
    //            }
    //        }
    //    }
    //}
}
// MARK: - ConfigureView
extension MainViewController {
    private func configureEssential() {
        navigationItem.title = "도봉러의 쇼핑쇼핑"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // mainView.shoppingSearchBar.delegate = self
    }
}
//
//// MARK: - Extension
//extension MainViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(#function)
//        
//        bfviewModel.inputSearchButtonTapped.value = searchBar.text
//
//        view.endEditing(true)
//    }
//}


