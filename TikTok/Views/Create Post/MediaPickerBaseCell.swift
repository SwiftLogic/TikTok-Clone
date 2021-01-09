//
//  //MediaPickerBaseCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 11/25/20.
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
protocol MediaPickerBaseCellDelegate: class {
    func didSelectMedia(asset: PHAsset)
    func didDeSelectMedia(asset: PHAsset)
    func didTapPreviewSelectedAssets(selectedAsset: PHAsset, allAssets: [PHAsset], currentIndexPath: IndexPath)

}
class MediaPickerBaseCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpViews()
    }
    
    
    
    
    //MARK: - Properties
    weak var delegate: MediaPickerBaseCellDelegate?
    var selectedMediaAssets = [PHAsset]()
    
    var imageAndVideoAssets :[PHAsset] = [] {
        didSet {
            collectionView.reloadData()
            if imageAndVideoAssets.isEmpty == false {
                handleRemoveLoadingView()
            }
        }
    }
    
    
    
    
    
    fileprivate let cellReuseId = "mediaBaseCellIdentifierfggggg"
    private let footerId = "footerResuidfforalbums"
     lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    
    let footerLabel: UILabel = {
        let label = UILabel()
       return label
   }()
    
    
    fileprivate let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .white)
        aiv.color = UIColor.darkGray
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }()
    
    
    fileprivate let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "LOADING"
        label.textColor = UIColor.darkGray
        return label
    }()
    

    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(MediaPickerCell.self, forCellWithReuseIdentifier: cellReuseId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: footerId)
        collectionView.contentInset = .init(top: 49, left: 0, bottom: 100, right: 0)
        collectionView.scrollIndicatorInsets = .init(top: 49, left: 0, bottom: 100, right: 0)
        handleSetUpLoadingView()

    }
    
    
    
    
   @objc func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage? {
          let thumbnailImage = PHLibraryAPI.shared.getAssetThumbnail(asset: asset, size: size)
         return thumbnailImage
     }
    
    
    
    fileprivate func handleSetUpLoadingView() {
           addSubview(activityIndicatorView)
           addSubview(loadingLabel)
           activityIndicatorView.centerInSuperview()
           loadingLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 6).isActive = true
           loadingLabel.centerXInSuperview()
           activityIndicatorView.startAnimating()
           collectionView.alpha = 0
       }
       
       
       @objc fileprivate func handleRemoveLoadingView() {
           activityIndicatorView.stopAnimating()
           activityIndicatorView.removeFromSuperview()
           loadingLabel.removeFromSuperview()
           UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
               self?.collectionView.alpha = 1
           }) {  (comletion) in
               
           }
       }
   
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




 //MARK: - CollectionView Delegate
extension MediaPickerBaseCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! MediaPickerCell
        let asset = imageAndVideoAssets[indexPath.item]
        let width = (frame.width) / 2.8
        let size = CGSize(width: width, height: width)
        cell.imageView.image = getAssetThumbnail(asset: asset, size: size)
        cell.phAsset = asset
        let videoLegthInString = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
        cell.videoDurationLabel.text = videoLegthInString
        cell.mediaPickerCellDelegate = self
        if selectedMediaAssets.contains(asset) {
            //selected cell
            handleSelectedCellUI(cell: cell)
        } else {
            //unselected cell
            handleDeSelectedCellUI(cell: cell)
        }
        return cell
    }
    
    
    fileprivate func handleSelectedCellUI(cell: MediaPickerCell) {
        cell.selectedCheckIconImageView.image = selectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
        cell.selectedCheckIconImageView.tintColor = tikTokRed
        cell.selectedCheckIconImageView.backgroundColor = .white
        
    }
    
    
    fileprivate func handleDeSelectedCellUI(cell: MediaPickerCell) {
        cell.selectedCheckIconImageView.image = unselectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
         cell.selectedCheckIconImageView.tintColor = .white
        cell.selectedCheckIconImageView.backgroundColor = .clear
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        delegate?.didTapPreviewSelectedAssets(selectedAsset: imageAndVideoAssets[indexPath.item], allAssets: imageAndVideoAssets, currentIndexPath: indexPath)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / 4 - 1
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAndVideoAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        footer.backgroundColor = .white
        handleSetUpFooterSubView(footer: footer)
        return footer
    }
    
    
    fileprivate func handleSetUpFooterSubView(footer: UICollectionReusableView) {
        footer.addSubview(footerLabel)
        footerLabel.centerInSuperview()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return imageAndVideoAssets.isEmpty == true ? CGSize(width: frame.width, height: frame.width) : .zero
    }
    
}



//MARK: - MediaPickerVCDelegate
extension MediaPickerBaseCell: MediaPickerVCDelegate {
    func didSelectMedia(asset: PHAsset) {}
    
    func isLoadingNewAlbumIntoDataSource() {
         handleSetUpLoadingView()
    }
    
    
    func didChangeAlbum(album: [PHAsset]) {
        if album.isEmpty == true && imageAndVideoAssets.isEmpty == true {
            handleRemoveLoadingView()
        } else {
            //this fixes a bug, sometimes the delegate doesnt remove our loadingIndicator despite datasource being empty
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.handleRemoveLoadingView()
            }
        }
    }
    
    
    func didTapRemoveSelected(asset: PHAsset) {
        if let index = selectedMediaAssets.firstIndex(of: asset) {
            selectedMediaAssets.remove(at: index)
            collectionView.reloadData() //refreshh our ui
        }
    }
    
    
}


//MARK: - MediaPickerCellDelegate
extension MediaPickerBaseCell : MediaPickerCellDelegate {
    
    func didSelectMediaCell(asset: PHAsset, cell: MediaPickerCell) {
        if selectedMediaAssets.contains(asset) {
            //de-selection
           selectedMediaAssets = selectedMediaAssets.filter { $0 != asset}
            delegate?.didDeSelectMedia(asset: asset)
            handleDeSelectedCellUI(cell: cell)
//           cell.selectedCountLabel.text = nil

        } else {
            // selection
            selectedMediaAssets.append(asset)
            delegate?.didSelectMedia(asset: asset)
            handleSelectedCellUI(cell: cell)
            
//            cell.selectedCheckIconImageView.image = UIImage()
//            cell.selectedCheckIconImageView.backgroundColor = tikTokRed
//            if let selectedNum = selectedMediaAssets.firstIndex(of: asset) {
//                let countString = selectedNum + 1
//                cell.selectedCountLabel.text = countString.formatUsingAbbrevation()
//            }
        }
                
    }
    
    
}
