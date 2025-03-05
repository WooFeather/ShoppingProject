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
    
    var saveData: ((Item) -> Void)?
    var deleteData: ((Int) -> Void)?
    var queryText = BehaviorRelay(value: "초기값")
    private let searchList = PublishRelay<[Item]>()
    private let repository: LikeItemRepository = LikeItemTableRepository()
    
    struct Input {
        let accuracyButtonTapped: ControlEvent<Void>
        let dateButtonTapped: ControlEvent<Void>
        let highPriceButtonTapped: ControlEvent<Void>
        let lowPriceButtonTapped: ControlEvent<Void>
        let backButtonTapped: ControlEvent<Void>?
    }
    
    struct Output {
        // 이전 뷰에서 query 스트링 넘겨받기
        let queryText: Driver<String>
        let searchList: Driver<[Item]>
        let totalCountText: Driver<String>
        let isItemEmpty: Driver<Bool>
        let backButtonTapped: Driver<Void>?
        let errorAlert: Driver<ErrorAlert>
        // 버튼 isSelected관련한 output
        let accuracyIsSelected: Driver<Bool>
        let dateIsSelected: Driver<Bool>
        let highPriceIsSelected: Driver<Bool>
        let lowPriceIsSelected: Driver<Bool>
    }
    
    func transfer(input: Input) -> Output {
        
        let totalCountText = PublishRelay<String>()
        let isItemEmpty = PublishRelay<Bool>()
        let errorAlert = PublishRelay<ErrorAlert>()
        
        let accuracyIsSelected = PublishRelay<Bool>()
        let dateIsSelected = PublishRelay<Bool>()
        let highPriceIsSelected = PublishRelay<Bool>()
        let lowPriceIsSelected = PublishRelay<Bool>()
        
        // 뷰에 들어오면 queryText를 통해 네트워크 통신
        queryText
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0)
                    .retry(3)
                    .catch { error in
                        switch error as? APIError {
                        case .invalidParameter:
                            errorAlert.accept(APIError.invalidParameter.errorAlert)
                        case .invalidAuthentication:
                            errorAlert.accept(APIError.invalidAuthentication.errorAlert)
                        case .callDenied:
                            errorAlert.accept(APIError.callDenied.errorAlert)
                        case .invalidURL:
                            errorAlert.accept(APIError.invalidURL.errorAlert)
                        case .invalidMethod:
                            errorAlert.accept(APIError.invalidMethod.errorAlert)
                        case .callLimitExceeded:
                            errorAlert.accept(APIError.callLimitExceeded.errorAlert)
                        case .serverError:
                            errorAlert.accept(APIError.serverError.errorAlert)
                        case .unknownError:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        default:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        }
                        
                        let data = SearchItem(totalCount: 0, items: [])
                        return Single.just(data)
                    }
            }
            .bind(with: self) { owner, value in
                owner.searchList.accept(value.items)
                totalCountText.accept("\(value.totalCount.formatted())개의 검색 결과")
                if value.items.isEmpty {
                    isItemEmpty.accept(true)
                } else {
                    isItemEmpty.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.accuracyButtonTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(queryText)
            // .distinctUntilChanged() -> 같은 검색어로 필터를 왔다갔다 하는 경우때문에 주석처리
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0, sort: .sim)
                    .retry(3)
                    .catch { error in
                        switch error as? APIError {
                        case .invalidParameter:
                            errorAlert.accept(APIError.invalidParameter.errorAlert)
                        case .invalidAuthentication:
                            errorAlert.accept(APIError.invalidAuthentication.errorAlert)
                        case .callDenied:
                            errorAlert.accept(APIError.callDenied.errorAlert)
                        case .invalidURL:
                            errorAlert.accept(APIError.invalidURL.errorAlert)
                        case .invalidMethod:
                            errorAlert.accept(APIError.invalidMethod.errorAlert)
                        case .callLimitExceeded:
                            errorAlert.accept(APIError.callLimitExceeded.errorAlert)
                        case .serverError:
                            errorAlert.accept(APIError.serverError.errorAlert)
                        case .unknownError:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        default:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        }
                        
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
                if value.items.isEmpty {
                    isItemEmpty.accept(true)
                } else {
                    isItemEmpty.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.dateButtonTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(queryText)
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0, sort: .date)
                    .retry(3)
                    .catch { error in
                        switch error as? APIError {
                        case .invalidParameter:
                            errorAlert.accept(APIError.invalidParameter.errorAlert)
                        case .invalidAuthentication:
                            errorAlert.accept(APIError.invalidAuthentication.errorAlert)
                        case .callDenied:
                            errorAlert.accept(APIError.callDenied.errorAlert)
                        case .invalidURL:
                            errorAlert.accept(APIError.invalidURL.errorAlert)
                        case .invalidMethod:
                            errorAlert.accept(APIError.invalidMethod.errorAlert)
                        case .callLimitExceeded:
                            errorAlert.accept(APIError.callLimitExceeded.errorAlert)
                        case .serverError:
                            errorAlert.accept(APIError.serverError.errorAlert)
                        case .unknownError:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        default:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        }
                        
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
                if value.items.isEmpty {
                    isItemEmpty.accept(true)
                } else {
                    isItemEmpty.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.highPriceButtonTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(queryText)
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0, sort: .dsc)
                    .retry(3)
                    .catch { error in
                        switch error as? APIError {
                        case .invalidParameter:
                            errorAlert.accept(APIError.invalidParameter.errorAlert)
                        case .invalidAuthentication:
                            errorAlert.accept(APIError.invalidAuthentication.errorAlert)
                        case .callDenied:
                            errorAlert.accept(APIError.callDenied.errorAlert)
                        case .invalidURL:
                            errorAlert.accept(APIError.invalidURL.errorAlert)
                        case .invalidMethod:
                            errorAlert.accept(APIError.invalidMethod.errorAlert)
                        case .callLimitExceeded:
                            errorAlert.accept(APIError.callLimitExceeded.errorAlert)
                        case .serverError:
                            errorAlert.accept(APIError.serverError.errorAlert)
                        case .unknownError:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        default:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        }
                        
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
                if value.items.isEmpty {
                    isItemEmpty.accept(true)
                } else {
                    isItemEmpty.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.lowPriceButtonTapped
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(queryText)
            .flatMap {
                NetworkManager.shared.callSearchAPI(query: $0, sort: .asc)
                    .retry(3)
                    .catch { error in
                        switch error as? APIError {
                        case .invalidParameter:
                            errorAlert.accept(APIError.invalidParameter.errorAlert)
                        case .invalidAuthentication:
                            errorAlert.accept(APIError.invalidAuthentication.errorAlert)
                        case .callDenied:
                            errorAlert.accept(APIError.callDenied.errorAlert)
                        case .invalidURL:
                            errorAlert.accept(APIError.invalidURL.errorAlert)
                        case .invalidMethod:
                            errorAlert.accept(APIError.invalidMethod.errorAlert)
                        case .callLimitExceeded:
                            errorAlert.accept(APIError.callLimitExceeded.errorAlert)
                        case .serverError:
                            errorAlert.accept(APIError.serverError.errorAlert)
                        case .unknownError:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        default:
                            errorAlert.accept(APIError.unknownError.errorAlert)
                        }
                        
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
                if value.items.isEmpty {
                    isItemEmpty.accept(true)
                } else {
                    isItemEmpty.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        saveData = { [weak self] element in
            self?.repository.createItem(imageURL: element.image, mallName: element.mallName, titleName: element.title, price: element.price)
        }
        
        // TODO: 삭제기능 인덱스 문제 수정해야될듯 => DB에서는 삭제 확인했는데, 좋아요페이지에는 있음
        deleteData = { [weak self] index in
            let data = self?.repository.fetchAll()
            let deleteData = data?[index]
            
            self?.repository.deleteItem(data: deleteData ?? LikeItem(imageURL: "", mallName: "", titleName: "", price: ""))
        }
        
        return Output(
            queryText: queryText.asDriver(),
            searchList: searchList.asDriver(onErrorJustReturn: []),
            totalCountText: totalCountText.asDriver(onErrorJustReturn: ""),
            isItemEmpty: isItemEmpty.asDriver(onErrorJustReturn: false),
            backButtonTapped: input.backButtonTapped?.asDriver(),
            errorAlert: errorAlert.asDriver(onErrorJustReturn: ErrorAlert(title: "", message: "")),
            accuracyIsSelected: accuracyIsSelected.asDriver(onErrorJustReturn: false),
            dateIsSelected: dateIsSelected.asDriver(onErrorJustReturn: false),
            highPriceIsSelected: highPriceIsSelected.asDriver(onErrorJustReturn: false),
            lowPriceIsSelected: lowPriceIsSelected.asDriver(onErrorJustReturn: false)
        )
    }
}
