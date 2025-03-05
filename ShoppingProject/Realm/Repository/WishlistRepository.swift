//
//  WishlistRepository.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/5/25.
//

import Foundation
import RealmSwift

protocol WishlistRepository {
    func getFileURL()
    func fetchAll() -> Results<Wishlist>
    // TODO: 폴더 안에 create하는 메서드로 변경
    func createItem(name: String)
    func deleteItem(data: Wishlist)
    func updateItem(data: Wishlist)
}

final class WishlistTableRepository: WishlistRepository {
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }
    
    func fetchAll() -> Results<Wishlist> {
        let data = realm.objects(Wishlist.self)
            .sorted(byKeyPath: "date", ascending: false)
            .where { $0.isDeleted == false }
        
        return data
    }
    
    func createItem(name: String) {
        do {
            try realm.write {
                let data = Wishlist(name: name)
                
                realm.add(data)
            }
        } catch {
            print("realm 데이터 저장 실패")
        }
    }
    
    func deleteItem(data: Wishlist) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("realm 데이터 삭제 실패")
        }
    }
    
    // 삭제 처리를 하기 위한 수정 메서드
    func updateItem(data: Wishlist) {
        do {
            try realm.write {
                realm.create(Wishlist.self, value: [
                    "id": data.id,
                    "isDeleted": true
                ], update: .modified)
            }
        } catch {
            print("렘 데이터 수정 실패")
        }
    }
}
