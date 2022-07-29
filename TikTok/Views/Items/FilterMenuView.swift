//
//  FilterMenuView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/5/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
protocol FilterMenuViewDelegate: AnyObject {
    func scrollToMenu(atIndexPath indexPath: IndexPath)

}
class FilterMenuView: UIView {
    
    
    //MARK: - Init
    //this how to do a custom init
    required init(menuTitles: [String]) {
        self.menuTitles = menuTitles
        super.init(frame: CGRect.zero)
        setUpViews()
        
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    weak var delegate: FilterMenuViewDelegate?
    static let lineSpacing: CGFloat = 6.5
    fileprivate let cellReuseId = "filterViewCellId"
    
    private let menuTitles: [String]
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = false
        return collectionView
    }()
    
    
    var horizontalBarLeftConstraint : NSLayoutConstraint?
    let horizontalBarView : UIView = {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = .black
        horizontalBarView.clipsToBounds = true
        horizontalBarView.layer.cornerRadius = 0//2
        return horizontalBarView
    }()
    
    
    lazy var slidingBarView : UIView = {
        let horizontalBarView = UIView()
//        horizontalBarView.backgroundColor = UIColor.black
        horizontalBarView.clipsToBounds = true
        return horizontalBarView
    }()
    
    
    
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.contentInset = .init(top: 0, left: FilterMenuView.lineSpacing, bottom: 0, right: FilterMenuView.lineSpacing)
        
        collectionView.register(FilterMenuCell.self, forCellWithReuseIdentifier: cellReuseId)
        
        addSubview(horizontalBarView)
        horizontalBarView.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .zero, size: .init(width: 0, height: 2.5))
        
        horizontalBarLeftConstraint = horizontalBarView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor)
        horizontalBarLeftConstraint?.isActive = true
        
        let divisor = CGFloat(menuTitles.count)
        horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / divisor).isActive = true

        horizontalBarView.addSubview(slidingBarView)
        slidingBarView.constrainToBottom(paddingBottom: 0)
        slidingBarView.constrainHeight(constant: 3)
        slidingBarView.centerXAnchor.constraint(equalTo: horizontalBarView.centerXAnchor, constant: 0).isActive = true
        slidingBarView.constrainWidth(constant: 30)
        
        
        addSubview(bottomLine)
        bottomLine.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))

        handleSelectItem(atIndex: 0, animated: false)
        
        
    }
    
    
    func handleSelectItem(atIndex index: Int, animated: Bool) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        
//        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterMenuCell else {return}
//        let xPosition = cell.frame.origin.x
//        horizontalBarLeftConstraint?.constant = xPosition
//        UIView.animate(withDuration: 0.3) {[weak self] in
//            self?.layoutIfNeeded()
//        }
    }
    
    //MARK: - Target Selectors
}

//MARK: - CollectionView Delegates
extension FilterMenuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! FilterMenuCell
        cell.menuTitle = menuTitles[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(menuTitles.count)
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.scrollToMenu(atIndexPath: indexPath)
        handleSelectItem(atIndex: indexPath.item, animated: true)
        
//        if indexPath.item == 0 {
//            horizontalBarLeftConstraint?.constant = 150
//        }
//        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear) {[weak self] in
//            self?.layoutIfNeeded()
//        } completion: { onComplete in
//            //
//        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FilterMenuView.lineSpacing
    }
    
}
