//
//  Date+.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/26/25.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yy.MM.dd 추가됨"
        return dateFormatter.string(from: self)
    }
}
