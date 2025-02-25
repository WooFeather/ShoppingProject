//
//  APIError.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/25/25.
//

import Foundation

enum APIError: Error {
    // TODO: 에러코드에 대응할 수 있도록 변경
    case invalidURL
    case unknownResponse
    case statusError
}
