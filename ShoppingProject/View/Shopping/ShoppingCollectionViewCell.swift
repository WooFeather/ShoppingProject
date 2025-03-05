//
//  ShoppingCollectionViewCell.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import SnapKit

class ShoppingCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "ShoppingCollectionViewCell"
    var disposBag = DisposeBag()
    
    let thumbnailImageView = UIImageView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let likeButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        likeButton.isSelected = false
        disposBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
    }
    
    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerX.equalTo(snp.centerX)
            make.size.equalTo(180)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-10)
            make.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-10)
            make.size.equalTo(30)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            make.leading.equalTo(self).offset(16)
            make.height.equalTo(17)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(self).offset(16)
            make.width.equalTo(150)
            make.height.greaterThanOrEqualTo(21)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(16)
            make.height.equalTo(21)
        }
    }
    
    override func configureView() {
        DispatchQueue.main.async { [self] in
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.width / 8
            thumbnailImageView.clipsToBounds = true
        }
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.tintColor = .black
        likeButton.backgroundColor = .white
        DispatchQueue.main.async { [weak self] in
            self?.likeButton.layer.cornerRadius = (self?.likeButton.frame.width ?? 0) / 2
        }
        likeButton.clipsToBounds = true
        likeButton.isSelected = false
        
        mallNameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        mallNameLabel.textColor = .gray
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .systemGray3
        titleLabel.numberOfLines = 2
        
        priceLabel.font = .boldSystemFont(ofSize: 17)
        priceLabel.textColor = .white
    }
    
    func configureData(data: Item) {
        thumbnailImageView.kf.setImage(with: URL(string: data.image))
        mallNameLabel.text = data.mallName
        titleLabel.text = data.title.escapingHTML
        priceLabel.text = NumberFormattingManager.shared.numberFormatting(number: Int(data.price) ?? 0)
    }
    
    func configureRealmData(data: LikeItem) {
        thumbnailImageView.kf.setImage(with: URL(string: data.imageURL))
        mallNameLabel.text = data.mallName
        titleLabel.text = data.titleName.escapingHTML
        priceLabel.text = NumberFormattingManager.shared.numberFormatting(number: Int(data.price) ?? 0)
        likeButton.isSelected = data.likeStatus
    }
}
