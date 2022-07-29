//
//  SelectedAssetsView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/28/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Photos
protocol SelectedAssetsViewDelegate: class {
    func didUpdateSelectedAssets(selectedAssets: [PHAsset])
    func didTapRemoveSelected(asset: PHAsset)
    func didTapPreviewSelectedAssets(selectedAsset: PHAsset, allAssets: [PHAsset], currentIndexPath: IndexPath)
    func didTapNext(selectedAssets: [PHAsset])

}
class SelectedAssetsView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
        setUpViews()
        
        
    }
    
    
    
    
    //MARK: - Properties
    weak var delegate: SelectedAssetsViewDelegate?
    
    var selectedAssets = [PHAsset]() {
        didSet {
            delegate?.didUpdateSelectedAssets(selectedAssets: selectedAssets)
        }
    }
    
    fileprivate let label: UILabel = {
        let label = UILabel()
        label.text = "You can select both videos and photos"
        label.textColor = .gray
        label.font = avenirRomanFont(size: 13.5) //14
        return label
    }()
    
    
    fileprivate let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.8), for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = baseWhiteColor
        button.isEnabled = false
        button.titleLabel?.font = defaultFont(size: 13.5)
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleDidTapNext), for: .touchUpInside)
        return button
    }()
    

    fileprivate let lineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
        return view
    }()
    
    
    fileprivate let labelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let bottomContainerTranslation: CGFloat = 100

    fileprivate lazy var collectionViewContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.transform = CGAffineTransform(translationX: 0, y: bottomContainerTranslation)
        return view
    }()
    
    
    fileprivate let previewSelectedCellID = "previewSelectedCellID"
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(labelContainerView)
        labelContainerView.addSubview(lineSeperatorView)
        labelContainerView.addSubview(label)
        labelContainerView.addSubview(nextButton)
        insertSubview(collectionViewContainerView, belowSubview: labelContainerView) 
        
        
        
        labelContainerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 50))

        
        lineSeperatorView.anchor(top: labelContainerView.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
        
        label.centerYInSuperview()
        label.constrainToLeft(paddingLeft: 14)
        
        nextButton.centerYInSuperview()
        nextButton.constrainToRight(paddingRight: -12)
        nextButton.constrainWidth(constant: 80) //60
        nextButton.constrainHeight(constant: 35)
        
        
        collectionViewContainerView.anchor(top: nil, leading: leadingAnchor, bottom: labelContainerView.topAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 71))
        
        collectionViewContainerView.addSubview(collectionView)
        collectionView.anchor(top: collectionViewContainerView.topAnchor, leading: collectionViewContainerView.leadingAnchor, bottom: collectionViewContainerView.bottomAnchor, trailing: collectionViewContainerView.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))

        collectionView.register(SelectedAssetCell.self, forCellWithReuseIdentifier: previewSelectedCellID)
        
    }
    
    fileprivate func handleCollectionViewVisibility(show: Bool) {
        let bottomContainerTranslation = self.bottomContainerTranslation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {[weak self] in
            if show == true {
                self?.collectionViewContainerView.transform = .identity

            } else {
                self?.collectionViewContainerView.transform = CGAffineTransform(translationX: 0, y: bottomContainerTranslation)
            }
        })
    }
    
    
    @objc fileprivate func handleDidTapNext() {
        delegate?.didTapNext(selectedAssets: selectedAssets)
    }
    
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2020 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - DidSelectMediaDelegate
extension SelectedAssetsView: DidSelectMediaDelegate {
    func didDeSelectMedia(asset: PHAsset) {
        if let index = selectedAssets.firstIndex(of: asset) {
            let indexPath = IndexPath(item: index, section: 0)
            selectedAssets.remove(at: index)
            collectionView.deleteItems(at: [indexPath])
            nextButton.setTitle("Next (\(selectedAssets.count))", for: .normal)
            if selectedAssets.isEmpty == true {
                nextButton.isEnabled = false
                nextButton.backgroundColor = baseWhiteColor
                handleCollectionViewVisibility(show: false)
                isUserInteractionEnabled = false
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    
    func didSelectMedia(asset: PHAsset) {
        nextButton.isEnabled = true
        nextButton.backgroundColor = tikTokRed
        handleCollectionViewVisibility(show: true)
        isUserInteractionEnabled = true
        selectedAssets.append(asset)
        collectionView.reloadData()
        nextButton.setTitle("Next (\(selectedAssets.count))", for: .normal)
        if selectedAssets.count > 5 {
            if let index = selectedAssets.firstIndex(of: asset) {
                let indexPath = IndexPath(item: index, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    
    
    
}


//MARK: - CollectionView & SelectedAssetCellDelegate Delegates
extension SelectedAssetsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectedAssetCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewSelectedCellID, for: indexPath) as! SelectedAssetCell
        cell.phAsset = selectedAssets[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 55, height: 55)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didTapPreviewSelectedAssets(selectedAsset: selectedAssets[indexPath.item], allAssets: selectedAssets, currentIndexPath: indexPath)
    }
    
    func didTapRemoveSelected(asset: PHAsset) {
        delegate?.didTapRemoveSelected(asset: asset)
    }
}
