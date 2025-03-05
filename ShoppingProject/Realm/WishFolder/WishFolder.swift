//
//  WishFolder.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/5/25.
//

import Foundation
import RealmSwift

final class WishFolder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var wishlist: List<Wishlist>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
