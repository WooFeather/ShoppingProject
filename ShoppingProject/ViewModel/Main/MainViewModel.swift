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
        let wishlistButtonTapped: ControlEvent<Void>?
        let likeItemButtonTapped: ControlEvent<Void>?
    }
    
    struct Output {
        // 유효성 검사 Bool
        let isTextValidate: Driver<Bool>
        let queryText: Driver<String>
        let wishlistButtonTapped: Driver<Void>?
        let likeItemButtonTapped: Driver<Void>?
    }
    
    func transfer(input: Input) -> Output {
        let queryText = PublishRelay<String>()
        
        let isTextValidate =  input.searchButtonTapped
            .withLatestFrom(input.searchText)
            .map {
                let trimmingText = $0.trimmingCharacters(in: .whitespaces)
                if trimmingText.count < 2 {
                    queryText.accept(trimmingText)
                    return false
                } else {
                    queryText.accept(trimmingText)
                    return true
                }
            }
        
        return Output(
            isTextValidate: isTextValidate.asDriver(onErrorJustReturn: false),
            queryText: queryText.asDriver(onErrorJustReturn: ""),
            wishlistButtonTapped: input.wishlistButtonTapped?.asDriver(),
            likeItemButtonTapped: input.likeItemButtonTapped?.asDriver()
        )
    }
}
