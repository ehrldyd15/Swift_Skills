//
//  ViewController.swift
//  CollectionViewConpositionalLayout2
//
//  Created by Do Kiyong on 2023/08/16.
//

import UIKit

/*
 특정 Section에 대해 스크롤 방향을 반대로 설정할 수 있는 방법
 
 기존에는 수평스크롤을 넣고 싶은 경우, cell안에 collectionView를 하나 더 넣어서 수평 스크롤을 구현했지만 orthogonalScrollingBehavior를 사용하면 간결
 
 크게 자연스럽게 스크롤 되는 continuous와 paging 스크롤 되는 paging이 존재
 
 5가지 속성이 존재
 
 // Standard scroll view behavior: UIScrollViewDecelerationRateNormal
 case continuous

 // Scrolling will come to rest on the leading edge of a group boundary
 case continuousGroupLeadingBoundary

 // Standard scroll view paging behavior (UIScrollViewDecelerationRateFast) with page size == extent of the collection view's bounds
 case paging

 // Fractional size paging behavior determined by the sections layout group's dimension
 case groupPaging

 // Same of group paging with additional leading and trailing content insets to center each group's contents along the orthogonal axis
 case groupPagingCentered
 
 */

class ViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.getLayout())
        
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(view)
        
        return view
    }()
    
    private var dataSource: [MySection] = [
        .main(
            [
                .init(text: "(main 섹션) 아이템 1"),
                .init(text: "(main 섹션) 아이템 2"),
                .init(text: "(main 섹션) 아이템 3"),
                .init(text: "(main 섹션) 아이템 4"),
                .init(text: "(main 섹션) 아이템 5"),
                .init(text: "(main 섹션) 아이템 6"),
            ]
        ),
        .sub(
            [
                .init(text: "(sub 섹션) 아이템 1"),
                .init(text: "(sub 섹션) 아이템 2"),
                .init(text: "(sub 섹션) 아이템 3"),
                .init(text: "(sub 섹션) 아이템 4"),
                .init(text: "(sub 섹션) 아이템 5"),
                .init(text: "(sub 섹션) 아이템 6"),
                .init(text: "(sub 섹션) 아이템 7"),
                .init(text: "(sub 섹션) 아이템 8"),
                .init(text: "(sub 섹션) 아이템 9"),
                .init(text: "(sub 섹션) 아이템 10"),
                .init(text: "(sub 섹션) 아이템 11"),
            ]
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
        ])
        
        self.collectionView.dataSource = self
        
    }
    
    private func getLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            switch self.dataSource[sectionIndex] {
            case .main:
                return self.getListSection()
            case .sub:
                return self.getGridSection()
            }
        }
    }
    
    private func getListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        return NSCollectionLayoutSection(group: group)
    }
    
    private func getGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        
        // collectionView의 width에 3개의 아이템이 위치하도록 하는 것
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        
        // 현재 보여지고 있는 화면에 어떤 항목이 표시되는지 알 수 있는 api
        // section의 visibleItemsInvalidationHandler 프로퍼티에 클로저 내부에서 처리
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
            guard let ss = self else { return }
            
            let normalizedOffsetX = offset.x
            let centerPoint = CGPoint(x: normalizedOffsetX + ss.collectionView.bounds.width / 2, y: 20)
            
            visibleItems.forEach({ item in
                guard let cell = ss.collectionView.cellForItem(at: item.indexPath) else { return }
                UIView.animate(withDuration: 0.3) {
                    cell.transform = item.frame.contains(centerPoint) ? .identity : CGAffineTransform(scaleX: 0.9, y: 0.9)
                }
            })
        }
        
        return section
    }
    
    // 최초에 위 애니메이션이 적용되어야 하므로, 런타임에서 뷰의 크기가 정해졌을 때 performBatchUpdates 호출
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionView.performBatchUpdates(nil, completion: nil)
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .main(items):
            return items.count
        case let .sub(items):
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.id, for: indexPath) as! MyCell
        switch self.dataSource[indexPath.section] {
        case let .main(items):
            cell.prepare(text: items[indexPath.item].text)
        case let .sub(items):
            cell.prepare(text: items[indexPath.item].text)
        }
        
        return cell
    }
    
}
