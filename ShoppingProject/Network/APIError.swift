//
//  APIError.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/25/25.
//

import Foundation

struct ErrorAlert {
    let title: String
    let message: String
}

enum APIError: Error {
    case invalidParameter
    case invalidAuthentication
    case callDenied
    case invalidURL
    case invalidMethod
    case callLimitExceeded
    case serverError
    case unknownError
    
    var errorAlert: ErrorAlert {
        switch self {
        case .invalidParameter:
            ErrorAlert(title: "400ERROR: 요청 변수 확인", message: "필수 요청 변수가 없거나 요청 변수 이름이 잘못되었습니다.")
        case .invalidAuthentication:
            ErrorAlert(title: "401ERROR: 인증 실패", message: "클라이언트 아이디나 클라이언트 시크릿이 잘못되었거나 토큰이 만료되었습니다.")
        case .callDenied:
            ErrorAlert(title: "403ERROR: 호출 금지", message: "HTTPS가 아닌 HTTP로 호출했습니다.")
        case .invalidURL:
            ErrorAlert(title: "404ERROR: API 없음", message: "요청 URL이 잘못되었습니다.")
        case .invalidMethod:
            ErrorAlert(title: "405ERROR: 메서드 사용 안 함", message: "HTTP메서드를 잘못 호출했습니다.")
        case .callLimitExceeded:
            ErrorAlert(title: "429ERROR: 호출 한도 초과", message: "하루 호출 허용량 또는 초당 호출 허용량을 초과했습니다.")
        case .serverError:
            ErrorAlert(title: "500ERROR: 서버 오류", message: "서버에 오류가 발생했습니다.")
        case .unknownError:
            ErrorAlert(title: "알 수 없는 오류", message: "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.")
        }
    }
}
