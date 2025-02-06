//
//  MainViewModel.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/6/25.
//

import Foundation

class MainViewModel {
    
    let inputSearchButtonTapped: Observable<String?> = Observable(nil)
    
    let outputSearchButtonTapped: Observable<String?> = Observable(nil)
    let outputValidateAlert: Observable<Bool> = Observable(false)
    
    init() {
        inputSearchButtonTapped.lazyBind { _ in
            self.validateSearchText()
        }
    }
    
    private func validateSearchText() {
        guard let searchText = self.inputSearchButtonTapped.value else {
            print("텍스트가 nil")
            return
        }
        
        let trimmingText = searchText.trimmingCharacters(in: .whitespaces)
        
        if trimmingText.count < 2 {
            self.outputValidateAlert.value = true
        } else {
            self.outputValidateAlert.value = false
            self.outputSearchButtonTapped.value = self.inputSearchButtonTapped.value
        }
    }
}
