//
//  FontsCollectionView.swift
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
public let textViewFontSize: CGFloat = 25
protocol FontsCollectionViewDelegate: AnyObject {
    func didSelect(font: UIFont)
}
class FontsCollectionView: UICollectionViewCell {
    
    //MARK: - Init
    required init(selectedFont: UIFont) {
        self.selectedFont = selectedFont
        super.init(frame: CGRect.zero)
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    weak var delegate: FontsCollectionViewDelegate?
    
    fileprivate var selectedFont: UIFont
    
    fileprivate let fonts : [UIFont] = [defaultFont(size: textViewFontSize), UIFont(name: Fonts.typerWriter, size: textViewFontSize)!, UIFont(name: Fonts.handWriting, size: textViewFontSize)!, UIFont(name: Fonts.neon, size: textViewFontSize)!, UIFont(name: Fonts.serif, size: textViewFontSize)!]
    
    fileprivate let fontNames : [String] = ["Classic", "Typewriter", "Handwriting", "Neon", "Serif"]
    
    fileprivate let cellReuseIdentifier = "SamiSays11 CellId for FontsCollectionView-Collection"
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
        collectionView.register(FontsCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        perform(#selector(handleScrollToInitialSelectedFont), with: nil, afterDelay: 0.2)

    }
    
    
    fileprivate func handleSetUpCellSelection(indexPath: IndexPath, cell: UICollectionViewCell) {
        if fonts[indexPath.item] == selectedFont {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.white.cgColor
        } else {
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.init(white: 0.5, alpha: 0.5).cgColor
        }
    }
    
    @objc fileprivate func handleScrollToInitialSelectedFont() {
           if let item = fonts.firstIndex(of: selectedFont) {
               let indexPath = IndexPath(item: item, section: 0)
               collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
           }
       }
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - CollectionView Delegates
extension FontsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! FontsCell
        cell.clipsToBounds = true
        cell.layer.cornerRadius =  4
        cell.label.text = fontNames[indexPath.item]
        cell.font = fonts[indexPath.item]
        handleSetUpCellSelection(indexPath: indexPath, cell: cell)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = fonts[indexPath.item]
        let newResizedFont = UIFont(name: font.fontName, size: fontSizeInCell)!
        return CGSize(width: estimatedFrameForText(text: fontNames[indexPath.item], font: newResizedFont).width + 15, height: 27)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fonts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFont = fonts[indexPath.item]
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.didSelect(font: fonts[indexPath.item])
        collectionView.reloadData()
    }

    
    @objc func estimatedFrameForText(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options =  NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text) .boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : font], context: nil)
    }
    
    
}
