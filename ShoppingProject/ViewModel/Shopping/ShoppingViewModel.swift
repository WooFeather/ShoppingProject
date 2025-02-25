//
//  RxShoppingViewModel.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/25/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel {
    private let disposeBag = DisposeBag()
    
    var queryText = BehaviorRelay(value: "초기값")
    
    struct Input {
        
    }
    
    struct Output {
        // 이전 뷰에서 query 스트링 넘겨받기
        let queryText: BehaviorRelay<String>
    }
    
    func transfer(input: Input) -> Output {
        
        return Output(queryText: queryText)
    }
}
