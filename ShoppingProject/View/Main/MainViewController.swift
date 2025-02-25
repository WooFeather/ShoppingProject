//
//  MainViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()

    // MARK: - LifeCycle
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        configureEssential()
    }
    
    // MARK: - Functions
    private func bindData() {
        viewModel.outputSearchButtonTapped.lazyBind { data in
            let vc = ShoppingViewController()
            vc.viewModel.outputSearchText.value = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.outputValidateAlert.bind { state in
            if state {
                self.showAlert(title: "검색어를 다시 확인해주세요😭", message: "검색어는 2글자 이상이어야 합니다.", button: "확인") {
                    self.dismiss(animated: true)
                }
            } else {
                return
            }
        }
    }
}

// MARK: - Extension
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        viewModel.inputSearchButtonTapped.value = searchBar.text

        view.endEditing(true)
    }
}

// MARK: - ConfigureView
extension MainViewController {
    private func configureEssential() {
        navigationItem.title = "도봉러의 쇼핑쇼핑"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        mainView.shoppingSearchBar.delegate = self
    }
}
