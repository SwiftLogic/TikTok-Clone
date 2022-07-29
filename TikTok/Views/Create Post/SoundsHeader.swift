//
//  SoundsHeader.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/7/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
private let cellReuseIdentifier = "SoundsHeadercellReuseIdentifier"
class SoundsHeader: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false 
        return collectionView
    }()
    
    
    let colors = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.cyan, UIColor.magenta, UIColor.blue, UIColor.orange, UIColor.brown, UIColor.purple, UIColor.lightGray]
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = colors.count
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = UIColor(white: 0.5, alpha: 0.5)
        pc.addTarget(self, action: #selector(handleDidPanPageControl), for: .valueChanged)
        return pc
    }()
    
    
    fileprivate let menuFilter: FilterMenuView = {
        let view = FilterMenuView(menuTitles: ["Discover", "Favorites"])
        return view
    }()
        
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        backgroundColor = .white
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(menuFilter)
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: SoundsVC.horizontalSpacings, bottom: 0, right: SoundsVC.horizontalSpacings), size: .init(width: 0, height: 100))
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        pageControl.anchor(top: nil, leading: leadingAnchor, bottom: collectionView.bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 25))
        
        menuFilter.anchor(top: collectionView.bottomAnchor, leading: collectionView.leadingAnchor, bottom: nil, trailing: collectionView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
    }
    
    
    
    
    
    //MARK: - Target Selectors
    @objc func handleDidPanPageControl(pc: UIPageControl) {
        //MARK: BUG workaround, we are toggling collectionView pagination because there is a bug with the scrollToItem method in iOS 14 where devices that have pagination on do not get scrolled. so this toggle is a workaround
        collectionView.isPagingEnabled = false
        let indexpath = IndexPath(item: pc.currentPage, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
    }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - CollectionView Protocols
extension SoundsHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        cell.backgroundColor = colors[indexPath.item].withAlphaComponent(0.5)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / frame.width)
        pageControl.currentPage = pageNumber
    }
}
