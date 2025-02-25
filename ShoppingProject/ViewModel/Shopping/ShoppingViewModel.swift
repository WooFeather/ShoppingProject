//
//  ShoppingViewModel.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/6/25.
//

import Foundation
import Alamofire

final class ShoppingViewModel {
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputAccuracyButtonTapped: Observable<Void?> = Observable(nil)
    let inputDateButtonTapped: Observable<Void?> = Observable(nil)
    let inputHighPriceButtonTapped: Observable<Void?> = Observable(nil)
    let inputLowPriceButtonTapped: Observable<Void?> = Observable(nil)
    let inputBackButtonTapped: Observable<Void?> = Observable(nil)
    
    var outputSearchText: Observable<String?> = Observable(nil)
    let outputSearchItem: Observable<[Item]> = Observable([])
    let outputCountText: Observable<String?> = Observable(nil)
    let outputItemIsEmpty: Observable<Bool> = Observable(false)
    let outputBackButtonTapped: Observable<Void?> = Observable(nil)
    
    private lazy var query = outputSearchText.value
    
    // MARK: - Initializer
    init() {
        inputViewDidLoadTrigger.lazyBind { _ in
            print("🩷viewDidLoad bind", self.query ?? "")
            self.callRequest(query: self.query ?? "")
        }
        
        inputAccuracyButtonTapped.lazyBind { _ in
            self.callRequest(query: self.query ?? "", sort: .sim)
        }
        
        inputDateButtonTapped.lazyBind { _ in
            self.callRequest(query: self.query ?? "", sort: .date)
        }
        
        inputHighPriceButtonTapped.lazyBind { _ in
            self.callRequest(query: self.query ?? "", sort: .dsc)
        }
        
        inputLowPriceButtonTapped.lazyBind { _ in
            self.callRequest(query: self.query ?? "", sort: .asc)
        }
        
        inputBackButtonTapped.lazyBind { _ in
            self.outputBackButtonTapped.value = self.inputBackButtonTapped.value
        }
    }
    
    // MARK: - Functions
    private func callRequest(query: String, sort: RequestSort = .sim) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=100&start=1&sort=\(sort)"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
        
        print("💙 URL이야 \(url)")
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchItem.self) { response in
            switch response.result {
            case .success(let value):
                print("✅ SUCCESS")
                
                self.outputSearchItem.value = value.items
                self.outputCountText.value = "\(value.totalCount.formatted()) 개의 검색 결과"
                
                if self.outputSearchItem.value.count != 0 {
                    self.outputItemIsEmpty.value = false
                } else {
                    self.outputItemIsEmpty.value = true
                }
            case .failure(let error):
                print("❌ FAILURE \(error)")
            }
        }
    }
}
