//
//  SortButton.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit

// ButtonConfiguration 적용해보기
class SortButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle("\(title)    ", for: .normal)
        titleLabel?.textAlignment = .center
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .selected)
        setBackgroundColor(.black, for: .normal)
        setBackgroundColor(.white, for: .selected)
        clipsToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
