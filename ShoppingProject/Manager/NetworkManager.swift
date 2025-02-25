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
                value(.failure(APIError.invalidURL))
                return Disposables.create {
                    print("🗑️ Disposed")
                }
            }
            
            AF.request(url, method: .get, headers: header)
                .validate(statusCode: 200..<299)
                .responseDecodable(of: SearchItem.self) { response in
                switch response.result {
                case .success(let data):
                    print("✅ SUCCESS", url)
                    print("🙋‍♀️ STATUS CODE \(response.response?.statusCode ?? 000)")
                    value(.success(data))
                case .failure(let error):
                    print("❌ FAILURE \(error)")
                    print("🙋‍♀️ STATUS CODE \(response.response?.statusCode ?? 000)")
                    
                    let errorStatusCode = response.response?.statusCode
                    switch errorStatusCode {
                    case 400:
                        value(.failure(APIError.invalidParameter))
                    case 401:
                        value(.failure(APIError.invalidAuthentication))
                    case 403:
                        value(.failure(APIError.callDenied))
                    case 404:
                        value(.failure(APIError.invalidURL))
                    case 405:
                        value(.failure(APIError.invalidMethod))
                    case 429:
                        value(.failure(APIError.callLimitExceeded))
                    case 500:
                        value(.failure(APIError.serverError))
                    default:
                        value(.failure(APIError.unknownError))
                    }
                }
            }
            
            return Disposables.create {
                print("🗑️ Disposed")
            }
        }
    }
}
