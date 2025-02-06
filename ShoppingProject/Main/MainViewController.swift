//
//  MainViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit

class MainViewController: UIViewController {
    
    var mainView = MainView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEssential()
    }
    
    func configureEssential() {
        mainView.shoppingSearchBar.delegate = self
        
        navigationItem.title = "도봉러의 쇼핑쇼핑"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        guard let searchText = searchBar.text else {
            // 텍스트가 없을 경우 return버튼이 비활성화되긴 함
            print("텍스트가 nil이당")
            return
        }
        
        let trimmingText = searchText.trimmingCharacters(in: .whitespaces)
        
        // 유효성검사(2글자 이상), 뷰전환(push), 값전달
        if trimmingText.count < 2 {
//            showAlert(title: "검색어를 다시 확인해주세요😭", message: "검색어는 2글자 이상이어야 합니다.")
            showAlert(title: "검색어를 다시 확인해주세요😭", message: "검색어는 2글자 이상이어야 합니다.", button: "확인") {
                self.dismiss(animated: true)
            }
        } else {
            let vc = ShoppingViewController()
            vc.navTitleContents = trimmingText
            navigationController?.pushViewController(vc, animated: true)
        }
        
        view.endEditing(true)
    }
}
