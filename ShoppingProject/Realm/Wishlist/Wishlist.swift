//
//  Wishlist.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/5/25.
//

import Foundation
import RealmSwift

final class Wishlist: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var date: Date
    @Persisted var isDeleted: Bool = false
    @Persisted(originProperty: "wishlist") var folder: LinkingObjects<WishFolder>
    
    convenience init(name: String) {
        self.init()
        self.name = name
        self.date = Date()
    }
}
