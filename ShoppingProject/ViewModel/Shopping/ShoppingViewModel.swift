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
    private let searchList = PublishRelay<[Item]>()
    
    struct Input {
        
    }
    
    struct Output {
        // 이전 뷰에서 query 스트링 넘겨받기
        let queryText: Driver<String>
        let searchList: Driver<[Item]>
        let totalCountText: Driver<String>
    }
    
    func transfer(input: Input) -> Output {
        
        let totalCountText = PublishRelay<String>()
        
        // 뷰에 들어오면 queryText를 통해 네트워크 통신
        queryText
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0)
                    .catch { error in
                        let data = SearchItem(totalCount: 0, items: [])
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
//                owner.searchItem.accept(value)
                owner.searchList.accept(value.items)
                totalCountText.accept("\(value.totalCount.formatted())개의 검색 결과")
            }
            .disposed(by: disposeBag)
        
        return Output(
            queryText: queryText.asDriver(),
            searchList: searchList.asDriver(onErrorJustReturn: []),
            totalCountText: totalCountText.asDriver(onErrorJustReturn: "")
        )
    }
}
