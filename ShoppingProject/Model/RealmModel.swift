//
//  RealmModel.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/4/25.
//

import Foundation
import RealmSwift

class LikeItem: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var imageURL: String
    @Persisted var mallName: String
    @Persisted(indexed: true) var titleName: String
    @Persisted var price: String
    @Persisted var likeStatus: Bool
    @Persisted var likeDate: Date
    
    convenience init(imageURL: String, mallName: String, titleName: String, price: String) {
        self.init()
        self.imageURL = imageURL
        self.mallName = mallName
        self.titleName = titleName
        self.price = price
        self.likeStatus = true
        self.likeDate = Date()
    }
}
