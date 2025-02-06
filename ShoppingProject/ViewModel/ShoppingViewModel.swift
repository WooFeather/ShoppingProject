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
    
    var outputSearchText: Observable<String?> = Observable(nil)
    let outputSearchItem: Observable<[Item]> = Observable([])
    let outputCountText: Observable<String?> = Observable(nil)
    
    private lazy var query = outputSearchText.value
    
    init() {
        inputViewDidLoadTrigger.lazyBind { _ in
            print("🩷viewDidLoad bind", self.query ?? "")
            self.callRequest(query: self.query ?? "")
        }
    }
    
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
                
                // TODO: 정렬버튼 눌렀을 때 상단으로 이동
//                if outputSearchItem.value.count != 0 {
//                    self.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
//                }
            case .failure(let error):
                print("❌ FAILURE \(error)")
            }
        }
    }
}
