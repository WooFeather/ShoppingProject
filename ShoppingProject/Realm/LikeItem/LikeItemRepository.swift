//
//  LikeItemRepository.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/5/25.
//

import Foundation
import RealmSwift

protocol LikeItemRepository {
    func getFileURL()
    func fetchAll() -> Results<LikeItem>
    func fetchFilteredItem(text: String) -> Results<LikeItem>
    func createItem(imageURL: String, mallName: String, titleName: String, price: String)
    func deleteItem(data: LikeItem)
}

final class LikeItemTableRepository: LikeItemRepository {
    private let realm = try! Realm()
    
    func getFileURL() {
        print(realm.configuration.fileURL ?? "URL 찾을 수 없음")
    }
    
    func fetchAll() -> Results<LikeItem> {
        let data = realm.objects(LikeItem.self)
            .sorted(byKeyPath: "likeDate", ascending: false)
        
        return data
    }
    
    func fetchFilteredItem(text: String) -> Results<LikeItem> {
        let data = realm.objects(LikeItem.self)
            .sorted(byKeyPath: "likeDate", ascending: false)
            .where { $0.titleName.contains(text, options: .caseInsensitive) }
        
        return data
    }
    
    func createItem(imageURL: String, mallName: String, titleName: String, price: String) {
        do {
            try realm.write {
                let data = LikeItem(
                    imageURL: imageURL,
                    mallName: mallName,
                    titleName: titleName,
                    price: price
                )
                
                realm.add(data)
            }
        } catch {
            print("realm 데이터 저장 실패")
        }
    }
    
    func deleteItem(data: LikeItem) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("realm 데이터 삭제 실패")
        }
    }
}
