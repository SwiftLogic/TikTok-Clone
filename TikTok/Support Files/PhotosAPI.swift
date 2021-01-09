//
//  PHLibrary.swift
//  InstagramCopy
//
//  Created by Osaretin Uyigue on 5/15/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Photos
class PHLibraryAPI {
    
    
    static let shared = PHLibraryAPI()
    
    ///responsible for fetching image from asset
    func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage? {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
//        options.version = .original //when turned on it crahes snapseed album when scrolling fast but it also fetches the right orientation of the image
        // the two lines below to fetch higher res images but beware of crashes when the phasset has a high PHImageManagerMaximumSize
//        options.resizeMode = .exact
//        options.deliveryMode = .highQualityFormat
//
        
        var thumbnail: UIImage?
        
        ///Tested & Proven Bug: - Sometimes when asset mediatype is video, if we request for a PHImageManagerMaximumSize as targetSize of requested image it might return nil image if the video thumbnail is blurry
            manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) {(imageReturned, info) in
                guard let thumbnailUnwrapped = imageReturned else {return}
                thumbnail = thumbnailUnwrapped
            }
       
        return thumbnail
    }
    
    
    
    
    
    
    
    ///responsible for fetching thumbnails of albums from photosfframework
    @objc func fetchAlbumThumbnail(collection: PHCollection, targetSize: CGSize, completion: @escaping (UIImage?) -> ()) {
        func fetchAsset(asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> ()) {
            let options = PHImageRequestOptions()
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            
            // We could use PHCachingImageManager for better performance here
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: options, resultHandler: { (image, info) in
                completion(image)
            })
        }
        
        func fetchFirstImageThumbnail(collection: PHAssetCollection, targetSize: CGSize, completion: @escaping (UIImage?) -> ()) {
            // We could sort by creation date here if we want
            let assets = PHAsset.fetchAssets(in: collection, options: PHFetchOptions())
            if let asset = assets.firstObject {
                fetchAsset(asset: asset, targetSize: targetSize, completion: completion)
            } else {
                completion(nil)
            }
        }
        
        
        if let collection = collection as? PHAssetCollection {
            let assets = PHAsset.fetchKeyAssets(in: collection, options: PHFetchOptions())
            
            if let keyAsset = assets?.firstObject {
                fetchAsset(asset: keyAsset, targetSize: targetSize) { (image) in
                    if let image = image {
                        completion(image)
                    } else {
                        fetchFirstImageThumbnail(collection: collection, targetSize: targetSize, completion: completion)
                    }
                }
            } else {
                fetchFirstImageThumbnail(collection: collection, targetSize: targetSize, completion: completion)
            }
        } else if let collection = collection as? PHCollectionList {
            // For folders we get the first available thumbnail from sub-folders/albums
            // possible improvement - make a "tile" thumbnail with 4 images
            let inner = PHCollection.fetchCollections(in: collection, options: PHFetchOptions())
            inner.enumerateObjects { (innerCollection, idx, stop) in
                self.fetchAlbumThumbnail(collection: innerCollection, targetSize: targetSize, completion: { (image) in
                    if image != nil {
                        completion(image)
                        stop.pointee = true
                    } else if idx >= inner.count - 1 {
                        completion(nil)
                    }
                })
            }
        } else {
            // We shouldn't get here
            completion(nil)
        }
    }

    
    
    
    
    
    
    func fetchLastAsset(completion: @escaping (PHAsset) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
            fetchOptions.fetchLimit = 1
            let predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
            
            fetchOptions.predicate = predicate
            let imagesAndVideos = PHAsset.fetchAssets(with: fetchOptions)
            
            DispatchQueue.main.async {
                for index in 0..<imagesAndVideos.count{
                    
                    let newlyRecordedVideoAsset = imagesAndVideos[index]
                    completion(newlyRecordedVideoAsset)
                    
                }
                
            }
        }
    }
    
    
    
    fileprivate func assetFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
//        fetchOptions.fetchLimit = 30
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d OR mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        return fetchOptions
        
    }
    
    
    
    fileprivate func handleFetchAssetsFromPhotosLibrary(phFetchOptions: PHFetchOptions, completion: @escaping ([PHAsset]) -> ()) {
        var assets = [PHAsset]()
        let imageAndVideoAssets = PHAsset.fetchAssets(with: phFetchOptions)
        
        DispatchQueue.global(qos: .background).async {
            
            for index in 0..<imageAndVideoAssets.count {
                
                assets.append((imageAndVideoAssets[index]))
                
            }
            
            DispatchQueue.main.async {
                
                completion(assets)
            }
            
        }
    }
    
    
    
    func getPhotosAndVideos(phFetchOptions: PHFetchOptions, completion: @escaping ([PHAsset]?, PHAuthorizationStatus) -> ()) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            
            handleFetchAssetsFromPhotosLibrary(phFetchOptions: phFetchOptions) { (assets) in
                completion(assets, status)
            }
            
            
        } else if (status == PHAuthorizationStatus.denied) {
            //show footer
            self.handleAskForAuthorization { (newStatus) in
                
                self.handleFetchAssetsFromPhotosLibrary(phFetchOptions: phFetchOptions) { (assets) in
                    completion(assets, newStatus)
                }
            }
            
        } else if (status == PHAuthorizationStatus.restricted) {
            //show footer
            self.handleAskForAuthorization { (newStatus) in
                
                self.handleFetchAssetsFromPhotosLibrary(phFetchOptions: phFetchOptions) { (assets) in
                    completion(assets, newStatus)
                }
            }
            
        } else if (status == PHAuthorizationStatus.notDetermined) {
            
            //show footer
            self.handleAskForAuthorization { (newStatus) in
                
                self.handleFetchAssetsFromPhotosLibrary(phFetchOptions: phFetchOptions) { (assets) in
                    completion(assets, newStatus)
                }
            }
        }
        
    }
    
    
    
    ///doesnt work once user denies access, access can only be regained from settings app or info plist
    fileprivate func handleAskForAuthorization(completion: @escaping (PHAuthorizationStatus) -> ()) {
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            
            if (newStatus == PHAuthorizationStatus.authorized) {
                
                
                completion(newStatus)
                
                
            } else {
                
                
                completion(newStatus)
                
            }
        })
        
    }
    
    

    
    ///fetch specific smart album
    func fetchSpecificSmartAlbum(collectionType: PHAssetCollectionType, collectionSubType: PHAssetCollectionSubtype, fetchOptions: PHFetchOptions, completion: @escaping ([PHAsset]) -> ()) {
        
        var assets = [PHAsset]()
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var fetchedAssets = PHFetchResult<PHAsset>()
        
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: collectionType, subtype: collectionSubType, options: nil)
        
        if let firstObject = collection.firstObject {
            //found the album
            assetCollection = firstObject
            albumFound = true
        }
            
        else { albumFound = false }
        
        _ = collection.count
        fetchedAssets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
        
        DispatchQueue.global(qos: .background).async {
            
            for index in 0..<fetchedAssets.count {
                
                assets.append((fetchedAssets[index]))
                
            }
            
            DispatchQueue.main.async {
                completion(assets)
            }
            
        }
        
    }
    
    
    
    ///fetch specific custom user album
    func fetchSpecificUserAlbum(albumName: String, collectionType: PHAssetCollectionType, collectionSubType: PHAssetCollectionSubtype, completion: @escaping ([PHAsset]) -> ()) {
        
        var assets = [PHAsset]()
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var fetchedAssets = PHFetchResult<PHAsset>()
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
            albumFound = true
        }
        else { albumFound = false }
        _ = collection.count
        
        fetchedAssets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        
        DispatchQueue.global(qos: .background).async {
            
            for index in 0..<fetchedAssets.count {
                
                assets.append((fetchedAssets[index]))
                
            }
            
            DispatchQueue.main.async {
                completion(assets.reversed()) // so we get it with latest image at top
            }
            
        }
        
    }
    
    
    
    ///media storage to phasset
    func createAlbum(withTitle title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            var placeholder: PHObjectPlaceholder?
            
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { (created, error) in
                var album: PHAssetCollection?
                if created {
                    let collectionFetchResult = placeholder.map { PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [$0.localIdentifier], options: nil) }
                    album = collectionFetchResult?.firstObject
                }
                
                completionHandler(album)
            })
        }
        
    }
    
    
    func getAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", title)
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let album = collections.firstObject {
                completionHandler(album)
            } else {
                self.createAlbum(withTitle: title, completionHandler: { (album) in
                    completionHandler(album)
                })
            }
        }
    }
    
    
    ///saves image to specific album
    func save(photo: UIImage, toAlbum titled: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        getAlbum(title: titled) { (album) in
            DispatchQueue.global(qos: .background).async {
                PHPhotoLibrary.shared().performChanges({
                    let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo)
                    let assets = assetRequest.placeholderForCreatedAsset
                        .map { [$0] as NSArray } ?? NSArray()
                    let albumChangeRequest = album.flatMap { PHAssetCollectionChangeRequest(for: $0) }
                    albumChangeRequest?.addAssets(assets)
                }, completionHandler: { (success, error) in
                    completionHandler(success, error)
                })
            }
        }
    }


    ///saves video to regular camera roll and returns the phasset
    func saveVideoToCameraRollAndGrabPHAssetOfSavedVideo(capturedVideoUrl: URL, completion: @escaping (PHAsset?) -> ()) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: capturedVideoUrl)
        }) {  saved, error in
            if saved {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                
                guard let fetchLastPHAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {return}
                // fetchLastPHAsset is your latest PHAsset
                DispatchQueue.main.async {
                    completion(fetchLastPHAsset)

                }
                
                
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                //display label that shows there was an error saving video
            }
        }
    }
    
    
    ///saves video to GRINN ALBUM and returns it PHASSET
    func saveVideoToGrinnAlbum(videoUrl: URL, completion: @escaping (PHAsset?) -> ()) {
        var localIdentifier = String();
        
          getAlbum(title: "Grinn", completionHandler: { (album) in
            
            guard let albumUnwrapped = album else {return}
            PHPhotoLibrary.shared().performChanges({
                guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: albumUnwrapped) else {return}
                
                guard let createAssetRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl) else {return}
                
                let currentDate = Date()
                createAssetRequest.creationDate = currentDate //i edit the assets date to this
                
                let placeHolder = createAssetRequest.placeholderForCreatedAsset
                albumChangeRequest.addAssets([placeHolder!] as NSArray)
                if placeHolder != nil {
                    localIdentifier = (placeHolder?.localIdentifier)!
                }
                
            }) { (didSucceed, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        
                        completion(nil)
                        print("error failed to save:", error?.localizedDescription ?? "")
                        
                    } else if didSucceed == true {
                        let fetchOptions = PHFetchOptions()
                        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                        guard let fetchLastPHAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {return}
                        // fetchLastPHAsset is your latest PHAsset
                        DispatchQueue.main.async {
                            completion(fetchLastPHAsset)
                        }
                    }
                }
            }
        })
    }
    
    //    @objc func requestRecordedVideosPhAsset(completion: @escaping (PHAsset) -> ()) {
    //        DispatchQueue.global(qos: .background).async {
    //            let fetchOptions = PHFetchOptions()
    //            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
    //            fetchOptions.fetchLimit = 1
    //            let predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
    //
    //            fetchOptions.predicate = predicate
    //            let imagesAndVideos = PHAsset.fetchAssets(with: fetchOptions)
    //
    //            DispatchQueue.main.async {
    //                for index in 0..<imagesAndVideos.count{
    //
    //                   let newlyRecordedVideoAsset = imagesAndVideos[index]
    //                    completion(newlyRecordedVideoAsset)
    //
    //                }
    //
    //            }
    //        }
    //    }
    
    
    
    
    func handleSaveVideoFromRemoteServerToLocalUrl(urlString: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/video.mp4"
                DispatchQueue.main.async { [weak self] in
                    urlData.write(toFile: filePath, atomically: true)
                    let localURL = URL(fileURLWithPath: filePath)
                    //saves video to our apps album name
                    self?.saveVideoToGrinnAlbum(videoUrl: localURL, completion: { (phAssetOfSavedVideo) in
                        if phAssetOfSavedVideo != nil {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                }
            }
        }
    }
    
    
}



//extension PHAsset {
//
//    func getURL(completionHandler : @escaping ((_ responseURL : URL?, _ image: UIImage?, _ aVAsset: AVAsset?) -> Void)){
//        if self.mediaType == .image {
//            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
//            options.isNetworkAccessAllowed = true
//            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
//                return true
//            }
//            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
//                if let contentEditingInputUnwrapped = contentEditingInput {
//                    //                    completionHandler(contentEditingInputUnwrapped.fullSizeImageURL as URL?)
//                    completionHandler(contentEditingInputUnwrapped.fullSizeImageURL as URL?, contentEditingInputUnwrapped.displaySizeImage, nil)
//
//
//                }
//            })
//        } else if self.mediaType == .video {
//            let options: PHVideoRequestOptions = PHVideoRequestOptions()
//            options.version = .original
//            options.isNetworkAccessAllowed = true
//            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
//                if let urlAsset = asset as? AVURLAsset {
//
//                    let localVideoUrl: URL = urlAsset.url as URL
//                    //
//                    //                    let videoData = NSData(contentsOf: localVideoUrl)
//                    //
//                    //                    //MARK: The URL returned from the PHAssets is invalid for export, so i write the localVideoUrl to a temp direct, grab the url address of the temporary directory and use that to upload video URL to my DB. Then i clear all files and data stored in temp directory path.
//                    //                    let videoPath = NSTemporaryDirectory() + "tmpMovie.MOV"
//                    //                    let videoURL = NSURL(fileURLWithPath: videoPath)
//                    //                    let writeResult = videoData?.write(to: videoURL as URL, atomically: true)
//                    //
//                    //                    if let writeResult = writeResult, writeResult {
//                    //                        print("success: \(videoURL)")
//                    //                    }
//                    //                    else {
//                    //                        print("failure")
//                    //                    }
//                    //
//                    //                    completionHandler(videoURL as URL, nil, asset)
//                    completionHandler(localVideoUrl, nil, asset)
//
//                } else {
//                    completionHandler(nil, nil, nil)
//                }
//            })
//        }
//    }
//
//
//}
//
//
//
//
//extension FileManager {
//    func clearTmpDirectory() {
//        do {
//            let tmpDirURL = FileManager.default.temporaryDirectory
//            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
//            try tmpDirectory.forEach { file in
//                let fileUrl = tmpDirURL.appendingPathComponent(file)
//                try removeItem(atPath: fileUrl.path)
//                print("Success: removed temp fileUrl \(fileUrl), file: \(file)")
//            }
//        } catch {
//            //catch the error somehow or catch these hands
//            print(error)
//        }
//    }
//}
//
//
//
//
