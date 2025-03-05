//
//  WishFolderRepository.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/5/25.
//

import Foundation
import RealmSwift

protocol WishFolderRepository {
    func fetchAll() -> Results<WishFolder>
    func createItem(name: String)
}

final class WishFolderTableRepository: WishFolderRepository {
    private let realm = try! Realm()
    
    func fetchAll() -> RealmSwift.Results<WishFolder> {
        return realm.objects(WishFolder.self)
    }
    
    func createItem(name: String) {
        do {
            try realm.write {
                let wishFolder = WishFolder(name: name)
                realm.add(wishFolder)
            }
        } catch {
            print("폴더 저장 실패")
        }
    }
}
