//
//  LikeItemView.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/4/25.
//

import UIKit
import SnapKit

final class LikeItemView: BaseView {
    
    let resultCountLabel = UILabel()
    lazy var shoppingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    // TODO: 필터버튼으로 만들어보기
    let accuracyButton = SortButton(title: "정확도")
    let dateButton = SortButton(title: "날짜순")
    let highPriceButton = SortButton(title: "가격높은순")
    let lowPriceButton = SortButton(title: "가격낮은순")
    private lazy var buttons = [accuracyButton, dateButton, highPriceButton, lowPriceButton]
    
    let itemSearchBar = UISearchBar()
    
    override func configureHierarchy() {
        addSubview(itemSearchBar)
        addSubview(resultCountLabel)
        addSubview(shoppingCollectionView)
        buttons.forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        itemSearchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(itemSearchBar.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(17)
        }
        
//        for i in 0..<buttons.count {
//            if i == 0 {
//                buttons[i].snp.makeConstraints { make in
//                    make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
//                    make.leading.equalToSuperview().offset(12)
//                    make.height.equalTo(36)
//                }
//            } else {
//                buttons[i].snp.makeConstraints { make in
//                    make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
//                    make.leading.equalTo(buttons[i - 1].snp.trailing).offset(8)
//                    make.height.equalTo(36)
//                }
//            }
//        }
        
        shoppingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        itemSearchBar.tintColor = .white
        itemSearchBar.barTintColor = .black
        itemSearchBar.searchTextField.textColor = .white
        itemSearchBar.placeholder = "좋아요한 상품을 검색해보세요"
        
        resultCountLabel.font = .boldSystemFont(ofSize: 15)
        resultCountLabel.textColor = .green
        
        shoppingCollectionView.backgroundColor = .black
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionInset: CGFloat = 10
        let cellSpacing: CGFloat = 10
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (sectionInset * 2) - (cellSpacing)
        
        layout.itemSize = CGSize(width: cellWidth / 2, height: (cellWidth / 2) * 1.5)
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        return layout
    }
}
