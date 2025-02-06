//
//  String+.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/16/25.
//

import Foundation

// 치형님이 찾아주신 HTMLTag 지우기 extension ㅎㅎ
extension String {
    var escapingHTML: String {
        let patten = "<[^>]+>|&quot;|<b>|</b>" // 필요한 패턴을 |(or기호)와 함께 추가하기
        
        return self.replacingOccurrences(of: patten,
                                  with: "",
                                  options: .regularExpression,
                                  range: nil)
    }
}
