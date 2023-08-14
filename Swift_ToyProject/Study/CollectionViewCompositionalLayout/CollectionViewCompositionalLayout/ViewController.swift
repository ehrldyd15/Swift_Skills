//
//  ViewController.swift
//  CollectionViewCompositionalLayout
//
//  Created by Do Kiyong on 2023/08/11.
//

import UIKit

// CompositionalLayout의 구성은 Section + Group + Item
// 여기서 핵심은 group이며, group은 한 화면에 들어가는 item들을 묶는 단위
// 레이아웃을 구성할 때 section, group, item의 레이아웃을 설정하여 구현
// CompositionalLayout은 하나의 CollectionView에 섹션별로 다른 layout을 구성하기가 쉬운 장점이 존재

/*
CollectionView의 item 사이즈를 정하는 방법은 3가지
.absolute - 고정 크기
.estimated - 런타임에 변경
.fractional - 비율
 
let absoluteSize = NSCollectionLayoutSize(
    widthDimension: .absolute(32),
    heightDimension: .absolute(32)
)

let estimatedSize = NSCollectionLayoutSize(
    widthDimension: .estimated(120),
    heightDimension: .estimated(120)
)

let fractionalSize = NSCollectionLayoutSize(
    widthDimension: .fractionalWidth(0.2),
    heightDimension: .fractionalHeight(0.2)
)
*/

class ViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: Self.getLayout()) // <- collectionView를 초기화 할 때 레이아웃에 대한 메소드를 따로 정의하여 이 메소드만 주입
        
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.scrollIndicatorInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 4)
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(MyCell.self, forCellWithReuseIdentifier: "MyCell") // TODO: MyCell
        
        view.register(MyHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyHeaderFooterView")
        view.register(MyHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MyHeaderFooterView")
        view.register(MyHeaderFooterView.self, forSupplementaryViewOfKind: "MyLeftView", withReuseIdentifier: "MyHeaderFooterView")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // CompositionalLayout은 하나의 CollectionView에 섹션별로 다른 layout을 구성하기가 쉬운 장점이 존재
    // UICollectionViewCompositionalLayout 인스턴스에서 section별로 분기문을 써서 layout을 다르게하기가 간편
    static func getLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                let itemFractionalWidthFraction = 1.0 / 3.0 // horizontal 3개의 셀
                let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
                let itemInset: CGFloat = 2.5
                
                // Item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                    heightDimension: .fractionalHeight(1)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(groupFractionalHeightFraction)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                // header / footer
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: UICollectionView.elementKindSectionFooter,
                    alignment: .bottom
                )
                
                let leftSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(700))
                
                let left = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: leftSize,
                    elementKind: "MyLeftView",
                    alignment: .leading
                )
                
                section.boundarySupplementaryItems = [header, footer, left]
                
                return section
            default:
                let itemFractionalWidthFraction = 1.0 / 5.0 // horizontal 5개의 셀
                let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
                let itemInset: CGFloat = 2.5
                
                // Item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                    heightDimension: .fractionalHeight(1)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(groupFractionalHeightFraction)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                return section
            }
        }
    }
    
    private let dataSource: [MySection] = [
      .first((1...30).map(String.init).map(MySection.FirstItem.init(value:))),
      .second((31...60).map(String.init).map(MySection.SecondItem.init(value:))),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
          self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
          self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
          self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
          self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        self.collectionView.dataSource = self
    }


}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .first(items):
            return items.count
        case let .second(items):
            return items.count
        }
    }
    
    // dataSource 델리게이트
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeaderFooterView", for: indexPath) as! MyHeaderFooterView
            
            header.prepare(text: "헤더 타이틀")
            
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeaderFooterView", for: indexPath) as! MyHeaderFooterView
            
            footer.prepare(text: "푸터 타이틀")
            
            return footer
        case "MyLeftView":
          let leftView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MyHeaderFooterView", for: indexPath) as! MyHeaderFooterView
            
          leftView.prepare(text: "left 타이틀")
            
          return leftView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        
        switch self.dataSource[indexPath.section] {
        case let .first(items):
            cell.prepare(text: items[indexPath.item].value)
        case let .second(items):
            cell.prepare(text: items[indexPath.item].value)
        }
        
        return cell
    }
    
}

enum MySection {
    case first([FirstItem])
    case second([SecondItem])
    
    struct FirstItem {
        let value: String
    }
    
    struct SecondItem {
        let value: String
    }
}
