//
//  MainView.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/17/25.
//

import UIKit
import SnapKit

class MainView: BaseView {
    
    let shoppingSearchBar = UISearchBar()
    let mainImageView = UIImageView()
    let mainLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(shoppingSearchBar)
        addSubview(mainImageView)
        addSubview(mainLabel)
    }
    
    override func configureLayout() {
        shoppingSearchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(200)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(21)
        }
    }
    
    override func configureView() {
        backgroundColor = .black
        
        shoppingSearchBar.tintColor = .white
        shoppingSearchBar.barTintColor = .black
        shoppingSearchBar.searchTextField.textColor = .white
        shoppingSearchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        
        mainImageView.image = .shoppingMain
        mainImageView.contentMode = .scaleAspectFill
        
        mainLabel.text = "쇼핑하구팡"
        mainLabel.font = .boldSystemFont(ofSize: 17)
        mainLabel.textColor = .white
    }
}
