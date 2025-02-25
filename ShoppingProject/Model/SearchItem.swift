//
//  SearchItem.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import Foundation

struct SearchItem: Decodable {
    let totalCount: Int
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total"
        case items
    }
}

struct Item: Decodable {
    let image: String
    let mallName: String
    let title: String
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case image
        case mallName
        case title
        case price = "lprice"
    }
}
