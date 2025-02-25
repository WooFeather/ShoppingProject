//
//  MainViewModel.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        // 검색버튼 탭
        let searchButtonTapped: ControlEvent<Void>
        // 검색 텍스트
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        // 유효성 검사 Bool
        let isTextValidate: Observable<Bool>
        let queryText: Observable<String>
    }
    
    func transfer(input: Input) -> Output {
        let queryText = BehaviorSubject(value: "")
        
        let isTextValidate =  input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .map {
                let trimmingText = $0.trimmingCharacters(in: .whitespaces)
                if trimmingText.count < 2 {
                    return false
                } else {
                    queryText.onNext(trimmingText)
                    return true
                }
            }
        
        return Output(
            isTextValidate: isTextValidate,
            queryText: queryText
        )
    }
}
