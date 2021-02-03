//
//  Extensions.swift
//  Instagram
//
//  Created by Swift Programming on 1/4/18.
//  Copyright © 2018 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Photos


import UIKit
extension UIColor {
    
    @objc static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let tealColor = UIColor(red: 48/255, green: 164/255, blue: 182/255, alpha: 1)
    static let lightRed = UIColor.init(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
    static let darkBlue = UIColor(red: 9/255, green: 45/255, blue: 64/255, alpha: 1)
    static let lightBlue = UIColor(red: 218/255, green: 235/255, blue: 243/255, alpha: 1)

}


extension UIView {
    @objc func anchor(top: NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        
        // the if let statements are used to unwrap the optional variables in the nslayoutaxis. while   the if width and height logic enables us to anchor the values when its not equal to zero
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
            
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    
    
    // Usage: insert view.pushTransition right before changing content
    
    func pushTransition(_ duration:CFTimeInterval, animationSubType: CATransitionSubtype) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = animationSubType
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    
}







extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
    
    
    func timeAgoDisplayingg() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        
        return "\(secondsAgo / week) weeks ago"
    }
    
    
    func timeDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "s"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "m"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "h"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "d"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "w"
        } else {
            quotient = secondsAgo / month
            unit = "mth"
        }
        
        return "\(quotient)\(unit)\(quotient == 1 ? "" : "")"
        
    }
    
}



extension Array where Element : Equatable{
    mutating func removeDuplicates() {
        
        var uniqueElems: [Element] = []
        
        for elem in self {
            
            if !uniqueElems.contains(elem) {
                uniqueElems.append(elem)
            }
        }
        
        self = uniqueElems
    }
}



//i finally fixed it
extension Int {

    func formatUsingAbbrevation () -> String {
        let n = self
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""
        
        switch num {
            
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)B"
            
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)M"
            
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)K"
            
        case 0...:
            return "\(n)"
            
        default:
            return "\(sign)\(n)"
            
        }
    }

}


extension Double {
    
    func truncate(places: Int) -> Double {
        
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
        
    }
    
}







extension PHAsset {
    
    @objc func getURL(completionHandler : @escaping ((_ responseURL : URL?, _ image: UIImage?, _ aVAsset: AVAsset?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = true
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                if let contentEditingInputUnwrapped = contentEditingInput {
                    //                    completionHandler(contentEditingInputUnwrapped.fullSizeImageURL as URL?)
                    completionHandler(contentEditingInputUnwrapped.fullSizeImageURL as URL?, contentEditingInputUnwrapped.displaySizeImage, nil)
                    
                    
                }
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    
                    let localVideoUrl: URL = urlAsset.url as URL
//
//                    let videoData = NSData(contentsOf: localVideoUrl)
//
//                    //MARK: The URL returned from the PHAssets is invalid for export, so i write the localVideoUrl to a temp direct, grab the url address of the temporary directory and use that to upload video URL to my DB. Then i clear all files and data stored in temp directory path.
//                    let videoPath = NSTemporaryDirectory() + "tmpMovie.MOV"
//                    let videoURL = NSURL(fileURLWithPath: videoPath)
//                    let writeResult = videoData?.write(to: videoURL as URL, atomically: true)
//
//                    if let writeResult = writeResult, writeResult {
//                        print("success: \(videoURL)")
//                    }
//                    else {
//                        print("failure")
//                    }
//
//                    completionHandler(videoURL as URL, nil, asset)
                    completionHandler(localVideoUrl, nil, asset)
                    
                } else {
                    completionHandler(nil, nil, nil)
                }
            })
        }
    }
    
    
}




extension FileManager {
    @objc func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
                print("Success: removed temp fileUrl \(fileUrl), file: \(file)")
            }
        } catch {
            //catch the error somehow or catch these hands
            print("error clearing temp directory: ", error.localizedDescription)
        }
    }
}



//func saveVideoToTempFileAndTrimFrom(completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
//    guard let localVideoUrl: URL = videoUrl else {return}
//    let videoData = NSData(contentsOf: localVideoUrl)
//    let videoPath = NSTemporaryDirectory() + "tmpMovie.MOV"
//    let videoURL = NSURL(fileURLWithPath: videoPath)
//    let writeResult = videoData?.write(to: videoURL as URL, atomically: true)
//
//    if let writeResult = writeResult, writeResult {
//        print("success: \(videoURL)")
//    }
//    else {
//        print("failure")
//    }
//
//    completionHandler(videoURL as URL)
//}






//    func getVideoUrl(referenceURL: URL) {
//        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
//        if let phAsset = fetchResult.firstObject as? PHAsset {
//            PHImageManager.default().requestAVAsset(forVideo: phAsset, options: PHVideoRequestOptions(), resultHandler: { (asset, audioMix, info) -> Void in
//                if let asset = asset as? AVURLAsset {
//                    let videoData = NSData(contentsOf: asset.url)
//
//                    // optionally, write the video to the temp directory
//                    let videoPath = NSTemporaryDirectory() + "tmpMovie.MOV"
//                    let videoURL = NSURL(fileURLWithPath: videoPath)
//                    let writeResult = videoData?.write(to: videoURL as URL, atomically: true)
//
//                    if let writeResult = writeResult, writeResult {
//                        print("success")
//                    }
//                    else {
//                        print("failure")
//                    }
//                }
//            })
//        }
//    }
//



//    //MARK: Not using this
//    func getAssetThumbnail(asset: PHAsset) -> UIImage {
//        let manager = PHImageManager.default()
//        let option = PHImageRequestOptions()
//        option.isNetworkAccessAllowed = true
//        option.deliveryMode = .highQualityFormat
//        var thumbnail = UIImage()
//        option.isSynchronous = true
//        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
//            if let returnedResult = result {
//                thumbnail = returnedResult
//
//            }
//        })
//        return thumbnail
//    }


//
//  Extensions+UIView.swift
//  SlideOutMenuInProgress
//
//  Created by Brian Voong on 9/30/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

// Reference Video: https://youtu.be/iqpAP7s3b-8
extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    @objc func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    @objc func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    
    
    
    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }
    
    
    func constrainToTop(paddingTop: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = superview?.topAnchor {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
    }
    
    
    func constrainToBottom(paddingBottom: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let bottom = superview?.bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
    }
    
    func constrainToLeft(paddingLeft: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let left = superview?.leftAnchor {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
    }
    
    
    func constrainToRight(paddingRight: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let right = superview?.rightAnchor {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
    }
    
    func constrainToRight(paddingRight: CGFloat, superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let right = superView.rightAnchor
        self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        
    }
    
    
    func constrainToTop(paddingTop: CGFloat, superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
         let top = superView.topAnchor
        self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    
    func constrainToBottom(paddingBottom: CGFloat, superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let bottom = superView.bottomAnchor
        self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        
    }
    
    
    
    
    func constrainToLeft(paddingLeft: CGFloat, superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        let left = superView.rightAnchor
        self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        
    }
    
    
    func centerYInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
    func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    
}


extension UIView {
    
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
    
    
    /// Flip view 180, slight delay then 360.
    func handleRotate360() {
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.45, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)
    }
    
    
    
    /// Flip view 180, true to rotate 180, false to return to identity
    func handleRotate180(rotate: Bool) {
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.transform = rotate == true ? CGAffineTransform(rotationAngle: CGFloat.pi) : .identity
        }
        
    }
    
    
    
}


public func generateVideoThumbnail(withfile videoUrl: URL) -> UIImage? {
    let asset = AVAsset(url: videoUrl)
    
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    do {
        let cmTime = CMTimeMake(value: 1, timescale: 60)
        let thumbnailCGImage = try imageGenerator.copyCGImage(at: cmTime, actualTime: nil)
        return UIImage(cgImage: thumbnailCGImage)
        
    } catch let err {
        print(err)
    }
    
    return nil
}

public func generateVideoThumbnailAt(cmTime: CMTime, withfile videoUrl: URL) -> UIImage? {
    let asset = AVAsset(url: videoUrl)
    
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    do {
        let thumbnailCGImage = try imageGenerator.copyCGImage(at: cmTime, actualTime: nil)
        return UIImage(cgImage: thumbnailCGImage)
        
    } catch let err {
        print(err)
    }
    
    return nil
}


public func handleAnimateHighLighted(view: UIView, highlighted: Bool) {
    //usingSpringWithDamping: 1, initialSpringVelocity: 1
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak view] in
        
        if highlighted == true {
            view?.transform = .init(scaleX: 0.9, y: 0.9) //0.9
            
            
        } else {
            
            view?.transform = .identity
        }
        
    }) { (completed) in
        //
    }
}


///removes all chars from textview
public func removeSpecialCharsFromString(_ str: String) -> String {
    struct Constants {
        static let validChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_")
    }
    return String(str.filter { Constants.validChars.contains($0)})
}


//public func removeSpecialCharsFromStringButLeaveWhiteSpaces(_ str: String) -> String {
//    struct Constants {
//        static let validChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_ ")
//    }
//    return String(str.filter { Constants.validChars.contains($0)})
//}


extension UILabel {
    func UILableTextShadow(color: UIColor){
        self.textColor = color
        self.layer.masksToBounds = false
        self.layer.shadowOffset = .zero//CGSize(width: 1, height: 1)
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 1.0
    }
}


extension String {
    var withoutSpecialCharacters: String {
        return self.components(separatedBy: CharacterSet.symbols).joined(separator: "")
    }
}



extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}




func defaultFont(size: CGFloat)-> UIFont {
    let defaultFont = UIFont(name: "AppleSDGothicNeo-Bold", size: size)!
    return defaultFont

}


func avenirRomanFont(size: CGFloat)-> UIFont {
    let defaultFont = UIFont(name: "Avenir-Roman", size: size)!
    return defaultFont
    
}



public func setupAttributedTextWithFonts(titleString: String, subTitleString: String, attributedTextColor: UIColor, mainColor: UIColor, mainfont: UIFont, subFont: UIFont) -> NSMutableAttributedString{
    let attributedText = NSMutableAttributedString(string: "\(titleString)", attributes: [NSAttributedString.Key.foregroundColor : mainColor, NSAttributedString.Key.font : mainfont])
    
    attributedText.append(NSMutableAttributedString(string: "\(subTitleString)", attributes: [NSAttributedString.Key.foregroundColor : attributedTextColor, NSAttributedString.Key.font: subFont]))
    return attributedText
}




public func handleHide_ShowNavLine(navController: UINavigationController?, showLine: Bool) {
    if showLine == true {
        navController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        navController?.navigationBar.shadowImage = UIImage(named: "")
    } else {
        navController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController?.navigationBar.shadowImage = UIImage()

    }
   
}



extension UICollectionView {
    
    func setupEmptyState(with message: String, animateIndicatorView: Bool) {
        
        let loadingLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.font = UIFont.boldSystemFont(ofSize: 10)
            label.textAlignment = .center
            label.textColor = .darkGray
            return label
        }()
        
        
        let indicatorView: UIActivityIndicatorView = {
            let iv = UIActivityIndicatorView(style: .white)
            iv.color = .darkGray
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        let collectionViewBackgroundView = UIView()
        collectionViewBackgroundView.addSubview(indicatorView)
        collectionViewBackgroundView.addSubview(loadingLabel)
        indicatorView.centerInSuperview()
        loadingLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 6).isActive = true
        loadingLabel.centerXInSuperview()
        animateIndicatorView == true ? indicatorView.startAnimating() : indicatorView.stopAnimating()
        self.backgroundView = collectionViewBackgroundView
    }
    
    
    func removeloadingView(afterDelay: TimeInterval) {
        //removes loading indicator and label with nice animation
        UIView.animate(withDuration: 0.5, delay: afterDelay, options: .curveEaseIn, animations: { [weak self] in
            self?.backgroundView = nil
        })
    }
}



class UILabelWithInsets : UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
        //canceld it out because im already doing it
        //        self.numberOfLines = 0
        //        self.adjustsFontSizeToFitWidth = true
        //        self.minimumScaleFactor = 0.1
        //        self.baselineAdjustment = .alignCenters
        
        
    }
}




public func handleSetUpAttributedText(titleString: String, secondString: String, mainColor: UIColor, mainfont: UIFont, secondColor: UIColor, subFont: UIFont, lastString: String, usernameMentionColor: UIColor, usernameString: String) -> NSMutableAttributedString {
       
       let mainAttributes = [NSAttributedString.Key.foregroundColor : mainColor, NSAttributedString.Key.font : mainfont]
       let mainAttributedText = NSMutableAttributedString(string: titleString, attributes: mainAttributes)
       
       
       let usernameAttributes = [NSAttributedString.Key.foregroundColor : usernameMentionColor, NSAttributedString.Key.font : subFont]

       let usernameTextAttribute = NSMutableAttributedString(string: usernameString, attributes: usernameAttributes)
       
       let subAttributes = [NSAttributedString.Key.foregroundColor : secondColor, NSAttributedString.Key.font : subFont]
       
       let subAttributedText = NSMutableAttributedString(string: secondString, attributes: subAttributes)
       
       let lastAttributes = [NSAttributedString.Key.foregroundColor : secondColor, NSAttributedString.Key.font : subFont]

       let lastAttributedText = NSMutableAttributedString(string: lastString, attributes: lastAttributes)
       
       
       mainAttributedText.append(subAttributedText)
       mainAttributedText.append(usernameTextAttribute)
       mainAttributedText.append(lastAttributedText)

       
       return mainAttributedText
   }
