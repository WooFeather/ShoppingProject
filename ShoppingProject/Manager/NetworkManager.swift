//
//  NetworkManager.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/25/25.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callSearchAPI(query: String, sort: RequestSort = .sim) -> Single<SearchItem> {
        return Single.create { value in
            
            let urlString = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=100&start=1&sort=\(sort)"
            
            let header: HTTPHeaders = [
                "X-Naver-Client-Id": APIKey.naverId,
                "X-Naver-Client-Secret": APIKey.naverSecret
            ]
            
            guard let url = URL(string: urlString) else {
                value(.failure(APIError.unknownResponse))
                return Disposables.create {
                    print("🗑️ Disposed")
                }
            }
            
            AF.request(url, method: .get, headers: header)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: SearchItem.self) { response in
                switch response.result {
                case .success(let data):
                    print("✅ SUCCESS")
                    value(.success(data))
                case .failure(let error):
                    print("❌ FAILURE \(error)")
                    value(.failure(error))
                }
            }
            
            return Disposables.create {
                print("🗑️ Disposed")
            }
        }
    }
}
