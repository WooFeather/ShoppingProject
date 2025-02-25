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
        let accuracyButtonTapped: ControlEvent<Void>
        let dateButtonTapped: ControlEvent<Void>
        let highPriceButtonTapped: ControlEvent<Void>
        let lowPriceButtonTapped: ControlEvent<Void>
        // TODO: BackButton 로직 작성
        let backButtonTapped: ControlEvent<Void>?
    }
    
    struct Output {
        // 이전 뷰에서 query 스트링 넘겨받기
        let queryText: Driver<String>
        let searchList: Driver<[Item]>
        let totalCountText: Driver<String>
        // 버튼 isSelected관련한 output
        let accuracyIsSelected: Driver<Bool>
        let dateIsSelected: Driver<Bool>
        let highPriceIsSelected: Driver<Bool>
        let lowPriceIsSelected: Driver<Bool>
    }
    
    func transfer(input: Input) -> Output {
        
        let totalCountText = PublishRelay<String>()
        let accuracyIsSelected = PublishRelay<Bool>()
        let dateIsSelected = PublishRelay<Bool>()
        let highPriceIsSelected = PublishRelay<Bool>()
        let lowPriceIsSelected = PublishRelay<Bool>()
        
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
                owner.searchList.accept(value.items)
                totalCountText.accept("\(value.totalCount.formatted())개의 검색 결과")
            }
            .disposed(by: disposeBag)
        
        input.accuracyButtonTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(queryText)
            // .distinctUntilChanged() -> 같은 검색어로 필터를 왔다갔다 하는 경우때문에 주석처리
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0, sort: .sim)
                    .catch { error in
                        let data = SearchItem(totalCount: 0, items: [])
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
                owner.searchList.accept(value.items)
                accuracyIsSelected.accept(true)
                [dateIsSelected, highPriceIsSelected, lowPriceIsSelected].forEach {
                    $0.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.dateButtonTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(queryText)
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0, sort: .date)
                    .catch { error in
                        let data = SearchItem(totalCount: 0, items: [])
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
                owner.searchList.accept(value.items)
                dateIsSelected.accept(true)
                [accuracyIsSelected, highPriceIsSelected, lowPriceIsSelected].forEach {
                    $0.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.highPriceButtonTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(queryText)
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0, sort: .dsc)
                    .catch { error in
                        let data = SearchItem(totalCount: 0, items: [])
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
                owner.searchList.accept(value.items)
                highPriceIsSelected.accept(true)
                [accuracyIsSelected, dateIsSelected, lowPriceIsSelected].forEach {
                    $0.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.lowPriceButtonTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(queryText)
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0, sort: .asc)
                    .catch { error in
                        let data = SearchItem(totalCount: 0, items: [])
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
                owner.searchList.accept(value.items)
                lowPriceIsSelected.accept(true)
                [accuracyIsSelected, dateIsSelected, highPriceIsSelected].forEach {
                    $0.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            queryText: queryText.asDriver(),
            searchList: searchList.asDriver(onErrorJustReturn: []),
            totalCountText: totalCountText.asDriver(onErrorJustReturn: ""),
            accuracyIsSelected: accuracyIsSelected.asDriver(onErrorJustReturn: false),
            dateIsSelected: dateIsSelected.asDriver(onErrorJustReturn: false),
            highPriceIsSelected: highPriceIsSelected.asDriver(onErrorJustReturn: false),
            lowPriceIsSelected: lowPriceIsSelected.asDriver(onErrorJustReturn: false)
        )
    }
}
