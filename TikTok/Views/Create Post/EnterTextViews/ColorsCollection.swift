//
//  ColorsCollection.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 2/16/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
protocol ColorsCollectionViewDelegate: AnyObject {
    func didSelect(color: UIColor)
}
class ColorsCollectionView: UIView {
    
    //MARK: - Init
    //this how to do a custom init
    required init(selectedColor: UIColor) {
        self.selectedColor = selectedColor
        super.init(frame: CGRect.zero)
        setUpViews()
    }


    
    
    //MARK: - Properties
    
    weak var delegate: ColorsCollectionViewDelegate?
    
    fileprivate let colors = [UIColor.white, UIColor.black, UIColor.rgb(red: 234, green: 64, blue: 64), UIColor.rgb(red: 255, green: 147, blue: 61), UIColor.rgb(red: 242, green: 205, blue: 70), UIColor.rgb(red: 120, green: 194, blue: 94), UIColor.rgb(red: 120, green: 200, blue: 166), UIColor.rgb(red: 53, green: 150, blue: 240), UIColor.rgb(red: 36, green: 68, blue: 179), UIColor.rgb(red: 87, green: 86, blue: 213), UIColor.rgb(red: 248, green: 215, blue: 233), UIColor.rgb(red: 164, green: 137, blue: 91), UIColor.rgb(red: 50, green: 82, blue: 60), UIColor.rgb(red: 47, green: 105, blue: 141), UIColor.rgb(red: 146, green: 151, blue: 158), UIColor.rgb(red: 51, green: 51, blue: 51)]
    
    
    fileprivate var selectedColor: UIColor
    
    

    
    
    fileprivate let cellReuseIdentifier = "SamiSays11 CellId for Colors Collection"
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
//        handleScrollToInitialSelectedColor()
        perform(#selector(handleScrollToInitialSelectedColor), with: nil, afterDelay: 0.2)
    }
    
    
    
    fileprivate func handleSetUpCellSelection(indexPath: IndexPath, cell: UICollectionViewCell) {
        if colors[indexPath.item] == selectedColor {
            cell.transform = CGAffineTransform(scaleX: 1.17, y: 1.17)
        } else {
            cell.transform = .identity
        }
    }
    
    
    @objc fileprivate func handleScrollToInitialSelectedColor() {
        if let item = colors.firstIndex(of: selectedColor) {
            let indexPath = IndexPath(item: item, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2021 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - CollectionView Delegates
extension ColorsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 25 / 2
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.white.cgColor
        handleSetUpCellSelection(indexPath: indexPath, cell: cell)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 25, height: 25)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.item]
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelect(color: colors[indexPath.item])
        collectionView.reloadData()
//        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak cell] in
//            cell?.transform = CGAffineTransform(scaleX: 1.17, y: 1.17)
//        }) {[weak self] (onComplete) in
////            self?.collectionView.reloadData()
//        }
    }
    
}
