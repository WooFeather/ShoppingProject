//
//  WishlistViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 2/26/25.
//

import UIKit
import SnapKit

struct Wishlist: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let date = Date()
}

final class WishlistViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }

    private let wishlistSearchBar = UISearchBar()
    lazy private var wishlistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Wishlist>?
    private var wishlistList: [Wishlist] = [
        Wishlist(name: "안경"),
        Wishlist(name: "에어팟"),
        Wishlist(name: "노트북"),
        Wishlist(name: "테슬라")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        updateSnapshot()
    }
    
    private func configureDataSource() {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Wishlist> { cell, indexPath, itemIdentifier in
            // ListCell / ViewConfiguration (Presentation)
            var content = UIListContentConfiguration.subtitleCell()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .cyan
            content.textProperties.font = .boldSystemFont(ofSize: 17)
            
            content.secondaryText = itemIdentifier.date.toString()
            content.secondaryTextProperties.color = .lightGray
            content.secondaryTextProperties.font = .systemFont(ofSize: 14)
            
            content.image = UIImage(systemName: "cart")
            content.imageProperties.tintColor = .white
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listAccompaniedSidebarCell()
            backgroundConfig.cornerRadius = 30
            backgroundConfig.strokeColor = .white
            backgroundConfig.strokeWidth = 2
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: wishlistCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            
            return cell
        }
    }
    
    // DiffableDataSource (Data)
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Wishlist>()
        snapshot.appendSections(Section.allCases) // 섹션
        snapshot.appendItems(wishlistList, toSection: .main) // 셀
        
        dataSource?.apply(snapshot)
    }
    
    // List Configuration (Layout)
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.backgroundColor = .black
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}

extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        wishlistList.remove(at: indexPath.item)
        
        updateSnapshot()
    }
}

extension WishlistViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let newWishlist = Wishlist(name: searchBar.text ?? "")
        wishlistList.insert(newWishlist, at: 0)
        
        updateSnapshot()
    }
}

extension WishlistViewController {
    private func configureView() {
        view.backgroundColor = .black
        navigationItem.title = "나만의 위시리스트"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        wishlistCollectionView.delegate = self
        wishlistSearchBar.delegate = self
        
        view.addSubview(wishlistSearchBar)
        view.addSubview(wishlistCollectionView)
        
        wishlistSearchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        wishlistCollectionView.snp.makeConstraints { make in
            make.top.equalTo(wishlistSearchBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        wishlistSearchBar.placeholder = "사고싶은 물품을 위시리스트에 추가해보세요"
        wishlistSearchBar.tintColor = .white
        wishlistSearchBar.barTintColor = .black
        wishlistSearchBar.searchTextField.textColor = .white
        
        wishlistCollectionView.backgroundColor = .black
    }
}
