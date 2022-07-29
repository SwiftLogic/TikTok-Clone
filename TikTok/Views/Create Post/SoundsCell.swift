//
//  SoundsCell.swift
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
private let cellReuseIdentier = "SoundsCellcellReuseIdentier"
class SoundsCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    let topBottomPadding: CGFloat = 12
    let lineSpacing: CGFloat = 10
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false 
        return collectionView
    }()
    
    
    
    let lineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    
    fileprivate let sectionTitle: UILabel = {
        let label = UILabel()
        label.text = "Pride: Hip-Hop"
        label.font = defaultFont(size: 15.2)
        return label
    }()
    
    
    fileprivate let allLabel: UILabel = {
        let label = UILabel()
        label.text = "All"
        label.font = defaultFont(size: 14.5)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        backgroundColor = .white
        addSubview(sectionTitle)
        sectionTitle.constrainToTop(paddingTop: 10)
        sectionTitle.constrainToLeft(paddingLeft: SoundsVC.horizontalSpacings)
        
        
        addSubview(allLabel)
        allLabel.constrainToTop(paddingTop: 10)
        allLabel.constrainToRight(paddingRight: -20)
        
        addSubview(collectionView)
        collectionView.anchor(top: sectionTitle.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        collectionView.register(FavoriteSoundsCell.self, forCellWithReuseIdentifier: cellReuseIdentier)
        
        addSubview(lineSeperatorView)
        lineSeperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: SoundsVC.horizontalSpacings, bottom: 0, right: SoundsVC.horizontalSpacings), size: .init(width: 0, height: 0.4))
        
        
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - CollectionView Protocols
extension SoundsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentier, for: indexPath) as! FavoriteSoundsCell
        cell.setImageForButton(imageName: "bookmark")
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (self.collectionView.frame.height - 2 * topBottomPadding - 2 * lineSpacing) / 3
        return .init(width: self.collectionView.frame.width - topBottomPadding, height: height)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
    

}
