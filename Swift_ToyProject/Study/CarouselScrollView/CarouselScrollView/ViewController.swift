//
//  ViewController.swift
//  CarouselScrollView
//
//  Created by Do Kiyong on 2023/08/18.
//

import UIKit

private var randomColor: UIColor {
    UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
}

class ViewController: UIViewController {
    
    private enum Const {
        static let itemSize = CGSize(width: 300, height: 300)
        static let itemSpacing = 24.0
        
        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - Self.itemSize.width) / 2.0
        }
        
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
        }
        
    }
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = Const.itemSize // <-
        layout.minimumLineSpacing = Const.itemSpacing // <-
        layout.minimumInteritemSpacing = 0
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewFlowLayout)
        
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: MyCollectionViewCell.id)
        view.isPagingEnabled = false // <- 한 페이지의 넓이를 조절 할 수 없기 때문에 scrollViewWillEndDragging을 사용하여 구현
        view.contentInsetAdjustmentBehavior = .never // <- 내부적으로 safe area에 의해 가려지는 것을 방지하기 위해서 자동으로 inset조정해 주는 것을 비활성화
        view.contentInset = Const.collectionViewContentInset // <-
        view.decelerationRate = .fast // <- 스크롤이 빠르게 되도록 (페이징 애니메이션같이 보이게하기 위함)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var items = (0...10).map { _ in randomColor }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: Const.itemSize.height),
            self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.id, for: indexPath) as! MyCollectionViewCell
        
        cell.prepare(color: self.items[indexPath.item])
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Const.itemSize.width + Const.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        
        print("targetContentOffset.pointee.x: ", targetContentOffset.pointee.x)
        print("scrollView.contentInset.left: ", scrollView.contentInset.left)
        print("scrolledOffsetX: ", scrolledOffsetX)
        print("cellWidth: ", cellWidth)
        print("index: ", index)
        
        print("x: ", index * cellWidth - scrollView.contentInset.left)
        print("y: ", scrollView.contentInset.top)
        
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
    
}
