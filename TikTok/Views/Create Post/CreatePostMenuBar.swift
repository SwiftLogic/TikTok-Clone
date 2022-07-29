//
//  CreatePostMenuBar.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 10/29/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
protocol CreatePostMenuBarDelegate: AnyObject {
    func didSelectMenu(at index: Int)
}
class CreatePostMenuBar: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        backgroundColor = .clear
    }
    
    
    
    
    //MARK: - Properties
    weak var delegate: CreatePostMenuBarDelegate?
    lazy var menuTitles: [String] = [" 60s", "15s", "Templates"]

    
    fileprivate let cellId = "To the architect of the universe"
    fileprivate let headerReuseIdentifier = "God is the greatest, headerReuseIdentifier"
    fileprivate let footerReuseIdentifier = "Lord is my savior, footerReuseIdentifier"

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
    
    
    
    fileprivate let whiteDotView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5 / 2
        return view
    }()
    
    
    //MARK: - Handlers
    
    @objc fileprivate func scrollToItem() {
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.alpha = 1
        }
    }
    
    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(CreatePostMenuCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)


        addSubview(whiteDotView)
        whiteDotView.centerXInSuperview()
        whiteDotView.constrainToBottom(paddingBottom: -5)
        whiteDotView.constrainHeight(constant: 5)
        whiteDotView.constrainWidth(constant: 5)
        alpha = 0
        perform(#selector(scrollToItem), with: nil, afterDelay: 0.1)
    }
    
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - CollectionView Protocols

extension CreatePostMenuBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CreatePostMenuCell
            cell.menuLabel.text = menuTitles[indexPath.item]
            cell.delegate = self
            return cell
        }
        
        
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width / CGFloat(menuTitles.count) / 1.8
            if indexPath.item == 2 {
                return .init(width: width + 20, height: frame.height)
            }
            return .init(width: width, height: frame.height)
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
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        delegate?.didSelectMenu(at: indexPath.item)
    }
        
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
//            header.backgroundColor = .red
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath)
//            footer.backgroundColor = .yellow
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width =  collectionView.frame.width  / 2.5 //3
        return .init(width: width, height: frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width =  collectionView.frame.width / 2.5 // 3
           return .init(width: width, height: frame.height)
       }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    

        
}




extension CreatePostMenuBar: CreatePostMenuCellDelegate {
    func didSelectCell(cell: CreatePostMenuCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        delegate?.didSelectMenu(at: indexPath.item)
    }
}

protocol CreatePostMenuCellDelegate: class {
    func didSelectCell(cell: CreatePostMenuCell)
}
class CreatePostMenuCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    weak var delegate: CreatePostMenuCellDelegate?
    let unselectedColor = UIColor.white.withAlphaComponent(0.7)
    lazy var menuLabel: UILabel = {
        let label = UILabel()
        label.textColor = unselectedColor//.gray
        label.font = defaultFont(size: 15)//UIFont.boldSystemFont(ofSize: 14.5)
        return label
    }()
    
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? .white : unselectedColor
            if isSelected == true {
                delegate?.didSelectCell(cell: self)
            }
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



extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            
            let indexPath = IndexPath(row: closestCellIndex, section: 0)
            
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            //S.B I added this last bit to achieve end result we desired
            self.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)


        }
    }
}


