//
//  Sticker.swift
//  Grinn Inc.
//  SamiSays11
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.

import UIKit


let defaultLabelFont = UIFont.boldSystemFont(ofSize: 25) // 30
var defaultFontSize = CGFloat(25) //CGFloat(30)


class Sticker: UIView {
    var appliedTranslation  = CGPoint(x: 0.0, y: 0.0)
    var appliedScale        = CGFloat(1.0)
    var appliedRotation     = CGFloat(0.0)
    
    
    var highlightLayer = CAShapeLayer()

    var text: String? {
        didSet {
            self.addSubview(label)
            clipsToBounds = true
        }
    }
    
    var containerBackGroundColor: UIColor! {
        didSet { backgroundColor = containerBackGroundColor } }
    
    
    var stickerFont: UIFont! {
        didSet {
            label.font = stickerFont
            textView.font = stickerFont
        }
    }
    
    
    var stickerTextColor: UIColor! {
        didSet {
            label.textColor = stickerTextColor
            textView.textColor = stickerTextColor
        }
    }
    

    
    var currentTextViewBackgroundColoringStyle: TextViewBackgroundColoringStyle!


    var stickerTextAlignment: NSTextAlignment! {
        didSet {
            label.textAlignment = stickerTextAlignment
            textView.textAlignment = stickerTextAlignment
        }
    }

    
    lazy var label: UILabelWithInsets = {
        let label = UILabelWithInsets(frame: frame)
        label.text = text
        //works well
        label.textInsets = UIEdgeInsets.init(top: 8, left: 20, bottom: 5, right: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = false
        return label
    }()

    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = text
        textView.backgroundColor = .white
        textView.font = stickerFont
        return textView
    }()
    
    
    // Placement: Used to track how much translation has already been applied while the finger remains down
    var translation = CGPoint(x: 0.0, y: 0.0) {
        didSet { self.updateTransform() }
    }
    
    // Scale: Used to track how much scaling has already been applied
    var scale = CGFloat(1.0) {
        didSet { self.updateTransform() }
    }
    
    // Rotation: Used to track how much rotation is applied while fingers are down
    var rotation = CGFloat(0.0) {
        didSet { self.updateTransform() }
    }
    
    
    
    
    func saveScale() {
        self.appliedScale = self.appliedScale * scale
        self.scale = CGFloat(1.0)
    }
    
    
    
    func saveTranslation() {
        self.appliedTranslation.x += translation.x
        self.appliedTranslation.y += translation.y
        translation = CGPoint(x: 0.0, y: 0.0)
    }
    
    
    
    
    func saveRotation() {
        self.appliedRotation = rotation
        rotation = CGFloat(0.0)
    }
    
    
    
    override var intrinsicContentSize: CGSize {
        get {
            
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 1
            label.sizeToFit()
            textView.textContainerInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
            layer.cornerRadius = 5
            let labelSize = CGSize(width: label.frame.size.width, height: label.frame.size.height + 5)//label.frame.size
            addSubview(textView)
            textView.fillSuperview()
            backgroundColor = .clear
            label.backgroundColor = .clear
            label.textColor = .clear
            textView.backgroundColor = .clear
            perform(#selector(handleSetUpShapeLayer), with: nil, afterDelay: 0)
            return labelSize
        }
    }
    

    
    
    @objc func handleSetUpShapeLayer() {
        highlightLayer.backgroundColor = nil
        highlightLayer.fillColor = containerBackGroundColor.cgColor
        highlightLayer.strokeColor = nil
        textView.layer.insertSublayer(highlightLayer, at: 0)
        perform(#selector(setHighlightPath), with: nil, afterDelay: 0)

    }
    
    @objc private func setHighlightPath() {
        let textLayer = textView.layer
        let textContainerInset = textView.textContainerInset
        let layout = textView.layoutManager
        let range = NSMakeRange(0, layout.numberOfGlyphs)
        var rects = [CGRect]()
        layout.enumerateLineFragments(forGlyphRange: range) { (_, usedRect, _, _, _) in
            if usedRect.width > 0 && usedRect.height > 0 {
                var rect = usedRect
                rect.origin.x += textContainerInset.left
                rect.origin.y += textContainerInset.top
                rect = self.highlightLayer.convert(rect, from: textLayer)
                rect = rect.insetBy(dx: 0, dy: -5)
                rects.append(rect)
            }
        }
        highlightLayer.path = CGPath.makeUnion(of: rects, cornerRadius: 5)
    }
    
    
    
    private func updateTransform() {
        let translationTransform    = CGAffineTransform(translationX: self.translation.x + appliedTranslation.x, y: self.translation.y + appliedTranslation.y)
        let scaleTransform          = CGAffineTransform(scaleX: scale * appliedScale, y: scale * appliedScale)
        let rotationTransform       = CGAffineTransform(rotationAngle: rotation + appliedRotation)
        
        self.transform = rotationTransform.concatenating(scaleTransform).concatenating(translationTransform)
    }
}
