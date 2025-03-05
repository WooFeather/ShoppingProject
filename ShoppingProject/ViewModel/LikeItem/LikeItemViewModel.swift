//
//  LikeItemViewModel.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/4/25.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class LikeItemViewModel {
    private let disposeBag = DisposeBag()
    private var likeItemList = PublishRelay<Results<LikeItem>>()
    private let repository: LikeItemRepository = LikeItemTableRepository()
    var likeButtonTapped: ((Int) -> Void)?
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let searchTextChanged: ControlProperty<String>
        let backButtonTapped: ControlEvent<Void>?
    }
    
    struct Output {
        let likeItemList: Driver<Results<LikeItem>>
        let likeListCount: Driver<Int>
        let backButtonTapped: Driver<Void>?
    }
    
    func transfer(input: Input) -> Output {
        
        let likeListCount = PublishRelay<Int>()
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                owner.repository.getFileURL()
                let data = owner.repository.fetchAll()
                owner.likeItemList.accept(data)
                likeListCount.accept(data.count)
            }
            .disposed(by: disposeBag)
        
        input.searchTextChanged
            .bind(with: self) { owner, text in
                if text.isEmpty {
                    let data = owner.repository.fetchAll()
                    owner.likeItemList.accept(data)
                    likeListCount.accept(data.count)
                } else {
                    let data = owner.repository.fetchFilteredItem(text: text)
                    owner.likeItemList.accept(data)
                    likeListCount.accept(data.count)
                }
            }
            .disposed(by: disposeBag)
        
        // 클로저로 삭제기능 구현 성공!!!
        likeButtonTapped = { [weak self] index in
            let data = self?.repository.fetchAll()
            let deleteData = data?[index]
            
            self?.repository.deleteItem(data: deleteData ?? LikeItem(imageURL: "", mallName: "", titleName: "", price: ""))
            
            self?.likeItemList.accept(data!) // 여기 강제 언래핑이 아쉽긴함...
            likeListCount.accept(data?.count ?? 0)
            print(index)
        }
        
        return Output(
            likeItemList: likeItemList.asDriver(onErrorJustReturn: repository.fetchAll()),
            likeListCount: likeListCount.asDriver(onErrorJustReturn: 0),
            backButtonTapped: input.backButtonTapped?.asDriver()
        )
    }
}
