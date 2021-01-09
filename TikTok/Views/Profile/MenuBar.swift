//
//  MenuBar.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/6/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
class TikTokMenuBar: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Properties
    let collectionViewWidth: CGFloat = 180
    
    weak var homeFeedController: HomeFeedController?

    lazy var menuTitles: [String] = ["Following", "For You"]
    
    fileprivate let cellId = "To the architect of the universe"
    
    var horizontalBarLeftConstraint: NSLayoutConstraint?
    
    var slidingBarViewLeadingAnchor: NSLayoutConstraint?
    
    var slidingBarViewWidthAnchor: NSLayoutConstraint?

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
   
    
    
    lazy var slidingBarView : UIView = {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.white//UIColor.rgb(red: 61, green: 42, blue: 187)//UIColor.rgb(red: 90, green: 100, blue: 207)//UIColor.black
        horizontalBarView.clipsToBounds = true
        return horizontalBarView
    }()
    
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    let followingCellSpacing: CGFloat = 28
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        addSubview(collectionView)
        addSubview(bottomLine)
        collectionView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .zero, size: .init(width: collectionViewWidth, height: 0))
        collectionView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10).isActive = true
        collectionView.register(TikTokMenuBarCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.selectItem(at: [0, 0], animated: false, scrollPosition: [])
        setUpHorizontalBarView()
    }
    
    
    
    fileprivate func setUpHorizontalBarView() {
        insertSubview(slidingBarView, belowSubview: collectionView)
        slidingBarView.constrainToBottom(paddingBottom: 0)
        slidingBarView.constrainHeight(constant: 3)
        slidingBarViewLeadingAnchor = slidingBarView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: followingCellSpacing)
        slidingBarViewLeadingAnchor?.isActive  = true
        slidingBarViewWidthAnchor = slidingBarView.widthAnchor.constraint(equalToConstant: 35)
        slidingBarViewWidthAnchor?.isActive = true
    }
    

}



//MARK: - CollectionView Delegates
extension TikTokMenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TikTokMenuBarCell
        cell.menuLabel.text = menuTitles[indexPath.item]
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
           let width: CGFloat = 93.3
           return .init(width: width, height: frame.height)
           
       } else {
           let width: CGFloat = 85
           return .init(width: width, height: frame.height)
           
       }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            homeFeedController?.scrollToMenuIndex(menuIndex: indexPath.item)
            handleScrollSlideBar(indexPath: indexPath)
        }
        
        
        func handleScrollSlideBar(indexPath: IndexPath) {

            if indexPath.item == 0 {
                
                slidingBarViewWidthAnchor?.constant = 35//90
                
                slidingBarViewLeadingAnchor?.constant = 30
              
            } else if indexPath.item == 1 {
                
                slidingBarViewWidthAnchor?.constant = 35//75
                
                slidingBarViewLeadingAnchor?.constant = (collectionViewWidth / 2) + followingCellSpacing
                
            }
           
            
            slidingBarViewWidthAnchor?.isActive = true
            slidingBarViewLeadingAnchor?.isActive = true

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {[weak self] in
                
                self?.layoutIfNeeded()
            }) { (completion) in
                //
            }
        }
        
}





class TikTokMenuBarCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? .white : .lightGray
        }
    }
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(menuLabel)
        menuLabel.centerInSuperview(size: .zero)
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
