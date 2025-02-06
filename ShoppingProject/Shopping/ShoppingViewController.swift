//
//  ShoppingViewController.swift
//  ShoppingProject
//
//  Created by 조우현 on 1/15/25.
//

import UIKit
import Alamofire
import SnapKit

class ShoppingViewController: UIViewController {

    lazy var shoppingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    let resultCountLabel = UILabel()
    let sampleButton = UIButton()
    var navTitleContents: String?
    
    let accuracyButton = SortButton(title: "정확도")
    let dateButton = SortButton(title: "날짜순")
    let highPriceButton = SortButton(title: "가격높은순")
    let lowPriceButton = SortButton(title: "가격낮은순")
    
    var start = 1
    var maxNum = 0
    
    var list: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        callRequest(query: navTitleContents ?? "")
        configureResultCountLabel()
        configureButtons()
        configureCollectionView()
        
        accuracyButton.isSelected = true
    }
    
    
    // 아래 부분 단순화
    @objc
    func accuracyButtonTapped() {
        print(#function)
        // 이부분도 단순화 할수있을거같은데
        accuracyButton.isSelected = true
        dateButton.isSelected = false
        highPriceButton.isSelected = false
        lowPriceButton.isSelected = false
        
        start = 1
        callRequest(query: navTitleContents ?? "", sort: .sim)
    }
    
    @objc
    func dateButtonTapped() {
        print(#function)
        accuracyButton.isSelected = false
        dateButton.isSelected = true
        highPriceButton.isSelected = false
        lowPriceButton.isSelected = false
        
        start = 1
        callRequest(query: navTitleContents ?? "", sort: .date)
    }
    
    @objc
    func highPriceButtonTapped() {
        print(#function)
        accuracyButton.isSelected = false
        dateButton.isSelected = false
        highPriceButton.isSelected = true
        lowPriceButton.isSelected = false
        
        start = 1
        callRequest(query: navTitleContents ?? "", sort: .dsc)
    }
    
    @objc
    func lowPriceButtonTapped() {
        print(#function)
        accuracyButton.isSelected = false
        dateButton.isSelected = false
        highPriceButton.isSelected = false
        lowPriceButton.isSelected = true
        
        start = 1
        callRequest(query: navTitleContents ?? "", sort: .asc)
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureView() {
        view.backgroundColor = .black
        navigationItem.title = navTitleContents
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
        
        // 네트워킹 -> 변수에 값 할당 -> 그 변수의 값 사용하려고 했는데 실패..
        // 이건 지금 방법이 최선임 만약 개선하고 싶다면 MainView에서 검색버튼을 눌렀을 때 네트워킹 통신을해서 ShoppingView의 viewDidLoad에서 보여줄순 있을듯
        // resultCountLabel.text = "\(totalCount.numberFormatting() ?? "") 개의 검색 결과"
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
        
        // 뭔가... selector함수도 하나로 만들어서 그 안에서 분기처리를 할 순 없을까?
        accuracyButton.addTarget(self, action: #selector(accuracyButtonTapped), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        highPriceButton.addTarget(self, action: #selector(highPriceButtonTapped), for: .touchUpInside)
        lowPriceButton.addTarget(self, action: #selector(lowPriceButtonTapped), for: .touchUpInside)
    }
    
    func configureCollectionView() {
        view.addSubview(shoppingCollectionView)
        
        shoppingCollectionView.delegate = self
        shoppingCollectionView.dataSource = self
        shoppingCollectionView.prefetchDataSource = self
        shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.id)
        
        shoppingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(accuracyButton.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        shoppingCollectionView.backgroundColor = .black
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
    
    func callRequest(query: String, sort: RequestSort = .sim) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&start=\(start)&sort=\(sort)"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverId,
            "X-Naver-Client-Secret": APIKey.naverSecret
        ]
        
        print("💙 URL이야 \(url)")
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchItem.self) { response in
            switch response.result {
            case .success(let value):
                print("✅ SUCCESS")

                self.resultCountLabel.text = "\(NumberFormattingManager.shared.numberFormatting(number: value.totalCount) ?? "") 개의 검색 결과"
                
                if value.totalCount > 100000 {
                    self.maxNum = 100000
                } else {
                    self.maxNum = value.totalCount
                }
                
                print("maxNum이야!! \(self.maxNum)")
                
                if self.start == 1 {
                    self.list = value.items
                } else {
                    self.list.append(contentsOf: value.items)
                }
                
                self.shoppingCollectionView.reloadData()
                
                // self.list.count != 0 이 조건을 추가해줌으로써 검색결과가 없을때 앱이 터지는걸 방지
                if self.start == 1 && self.list.count != 0 {
                    self.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
            case .failure(let error):
                print("❌ FAILURE \(error)")
            }
        }
    }
}

extension ShoppingViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("🔗indexPath야 \(indexPaths)")
        
        // max값을 구해서 분기처리 (10만보다 많으면 맥스값은 10만, 적으면 그 불러온 아이템수 값
        for item in indexPaths {
            if list.count - 3 == item.item {
                if list.count < maxNum {
                    start += 1
                    callRequest(query: navTitleContents ?? "")
                } else {
                    print("❗️마지막 페이지야!!")
                }
            }
        }
    }
}

extension ShoppingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = shoppingCollectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.id, for: indexPath) as? ShoppingCollectionViewCell else { return UICollectionViewCell() }
        
        let data = list[indexPath.row]
        cell.configureData(data: data)
        
        return cell
    }
}
