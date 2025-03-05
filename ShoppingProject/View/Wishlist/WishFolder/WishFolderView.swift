//
//  WishFolderView.swift
//  ShoppingProject
//
//  Created by 조우현 on 3/5/25.
//

import UIKit
import SnapKit

final class WishFolderView: BaseView {
    
    let folderTableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(folderTableView)
    }
    
    override func configureLayout() {
        folderTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        folderTableView.backgroundColor = .black
    }
}
