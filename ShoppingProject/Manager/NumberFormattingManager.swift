//
//  NumberFormattingManager.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/17/25.
//

import Foundation

class NumberFormattingManager {
    static let shared = NumberFormattingManager()
    
    private init() { }
    
    func numberFormatting(number: Int) -> String? {
        let nsNumber = NSNumber(value: number)
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .decimal
        
        if let formattedNumber = numberFormatter.string(from: nsNumber) {
            return formattedNumber
        } else {
            return nil
        }
    }
}
