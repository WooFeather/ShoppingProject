//
//  ShoppingViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit
import SnapKit

final class ShoppingViewController: UIViewController {

    lazy private var shoppingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    private let resultCountLabel = UILabel()
    private let sampleButton = UIButton()
//    private var navTitleContents: String?
    
    private let accuracyButton = SortButton(title: "정확도")
    private let dateButton = SortButton(title: "날짜순")
    private let highPriceButton = SortButton(title: "가격높은순")
    private let lowPriceButton = SortButton(title: "가격낮은순")
    
    let viewModel = ShoppingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureResultCountLabel()
        configureButtons()
        configureCollectionView()
        configureAction()
        bindData()
    }
    
    private func bindData() {
        viewModel.inputViewDidLoadTrigger.value = ()
        
        viewModel.outputSearchText.bind { text in
            self.navigationItem.title = text
        }
        
        viewModel.outputSearchItem.lazyBind { _ in
            self.shoppingCollectionView.reloadData()
        }
        
        viewModel.outputCountText.lazyBind { count in
            self.resultCountLabel.text = count
        }
    }
    
    @objc
    private func accuracyButtonTapped() {
        print(#function)
        // 이부분도 단순화 할수있을거같은데
        accuracyButton.isSelected = true
        dateButton.isSelected = false
        highPriceButton.isSelected = false
        lowPriceButton.isSelected = false
        
        // TODO: 정렬버튼 네트워크 통신
//        callRequest(query: viewModel.outputSearchText.value ?? "", sort: .sim)
    }
    
    @objc
    private func dateButtonTapped() {
        print(#function)
        accuracyButton.isSelected = false
        dateButton.isSelected = true
        highPriceButton.isSelected = false
        lowPriceButton.isSelected = false
        
//        callRequest(query: viewModel.outputSearchText.value ?? "", sort: .date)
    }
    
    @objc
    private func highPriceButtonTapped() {
        print(#function)
        accuracyButton.isSelected = false
        dateButton.isSelected = false
        highPriceButton.isSelected = true
        lowPriceButton.isSelected = false
        
//        callRequest(query: viewModel.outputSearchText.value ?? "", sort: .dsc)
    }
    
    @objc
    private func lowPriceButtonTapped() {
        print(#function)
        accuracyButton.isSelected = false
        dateButton.isSelected = false
        highPriceButton.isSelected = false
        lowPriceButton.isSelected = true
        
//        callRequest(query: viewModel.outputSearchText.value ?? "", sort: .asc)
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureAction() {
        accuracyButton.addTarget(self, action: #selector(accuracyButtonTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        highPriceButton.addTarget(self, action: #selector(highPriceButtonTapped), for: .touchUpInside)
        lowPriceButton.addTarget(self, action: #selector(lowPriceButtonTapped), for: .touchUpInside)
    }
}

//extension ShoppingViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("🔗indexPath야 \(indexPaths)")
//        
//        // max값을 구해서 분기처리 (10만보다 많으면 맥스값은 10만, 적으면 그 불러온 아이템수 값
//        for item in indexPaths {
//            if list.count - 3 == item.item {
//                if list.count < maxNum {
//                    start += 1
//                    callRequest(query: viewModel.outputSearchText.value ?? "")
//                } else {
//                    print("❗️마지막 페이지야!!")
//                }
//            }
//        }
//    }
//}

extension ShoppingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputSearchItem.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = shoppingCollectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.id, for: indexPath) as? ShoppingCollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.outputSearchItem.value[indexPath.row]
        cell.configureData(data: data)
        
        return cell
    }
}

extension ShoppingViewController {
    func configureView() {
        view.backgroundColor = .black
//        navigationItem.title = navTitleContents
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let chevron = UIImage(systemName: "chevron.left")
        let backButton = (UIBarButtonItem(image: chevron, style: .plain, target: self, action: #selector(backButtonTapped)))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureResultCountLabel() {
        view.addSubview(resultCountLabel)
        
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view).inset(12)
            make.height.equalTo(17)
        }

        resultCountLabel.font = .boldSystemFont(ofSize: 15)
        resultCountLabel.textColor = .green
    }
    
    func configureButtons() {
        let buttons = [accuracyButton, dateButton, highPriceButton, lowPriceButton]
        buttons.forEach { view.addSubview($0) }
        
        for i in 0..<buttons.count {
            if i == 0 {
                buttons[i].snp.makeConstraints { make in
                    make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
                    make.leading.equalTo(view).offset(12)
                    make.height.equalTo(36)
                }
            } else {
                buttons[i].snp.makeConstraints { make in
                    make.top.equalTo(resultCountLabel.snp.bottom).offset(10)
                    make.leading.equalTo(buttons[i - 1].snp.trailing).offset(8)
                    make.height.equalTo(36)
                }
            }
        }
        
        accuracyButton.isSelected = true
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
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
    
    private func configureCollectionView() {
        view.addSubview(shoppingCollectionView)
        
        shoppingCollectionView.delegate = self
        shoppingCollectionView.dataSource = self
//        shoppingCollectionView.prefetchDataSource = self
        shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
        
        shoppingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(accuracyButton.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        shoppingCollectionView.backgroundColor = .black
    }
}
