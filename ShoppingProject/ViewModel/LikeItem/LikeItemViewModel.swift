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
    private let realm = try! Realm()
    
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
                print(owner.realm.configuration.fileURL ?? "")
                let data = owner.realm.objects(LikeItem.self).sorted(byKeyPath: "likeDate", ascending: false)
                owner.likeItemList.accept(data)
                likeListCount.accept(data.count)
            }
            .disposed(by: disposeBag)
        
        input.searchTextChanged
            .bind(with: self) { owner, text in
                if text.isEmpty {
                    let data = owner.realm.objects(LikeItem.self).sorted(byKeyPath: "likeDate", ascending: false)
                    owner.likeItemList.accept(data)
                    likeListCount.accept(data.count)
                } else {
                    let data = owner.realm.objects(LikeItem.self).sorted(byKeyPath: "likeDate", ascending: false)
                        .where { $0.titleName.contains(text, options: .caseInsensitive) }
                    owner.likeItemList.accept(data)
                    likeListCount.accept(data.count)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            likeItemList: likeItemList.asDriver(onErrorJustReturn: realm.objects(LikeItem.self).sorted(byKeyPath: "likeDate", ascending: false)),
            likeListCount: likeListCount.asDriver(onErrorJustReturn: 0),
            backButtonTapped: input.backButtonTapped?.asDriver()
        )
    }
}
