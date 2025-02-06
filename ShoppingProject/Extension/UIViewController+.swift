//
//  UIViewController+.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit

// 강의자료 맨 마지막에 클로저 예시 참고해서 수정해보기
// 예를 들어 메인화면의 text를 "검색결과가 없어요"로 바꾼다든지? => 이걸 Alert에서?
// 이건 네트워킹 통신을 검색버튼을 누른 시점으로 하면 가능할듯?
extension UIViewController {
    func showAlert(title: String, message: String, button: String, isCancelButton: Bool = false  ,completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: button, style: .default) { action in
            completionHandler()
        }
        // 필요한 경우에만 cancelButton 사용하기!
        if isCancelButton {
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancel)
        }
        
        alert.addAction(button)
        
        present(alert, animated: true)
    }
}
