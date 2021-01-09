//
//  CommentInputTextView.swift
//  Meme
//
//  Created by Osaretin Uyigue on 3/22/18.
//  Copyright © 2018 Osaretin Uyigue. All rights reserved.
//

import UIKit
class CommentInputTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        returnKeyType = .done
        isScrollEnabled = false
        keyboardAppearance = .light
        tintColor = .red
        font = UIFont(name: "Avenir-Roman", size: 15.0)!
//        layer.cornerRadius = 5//18
        textColor = .black
        backgroundColor = UIColor.white
        returnKeyType = .send
//        layer.borderColor = UIColor.lightGray.cgColor//UIColor.darkGray.cgColor
//        layer.borderWidth = 0.8
//
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0) //padding left 8
    }
    
    
      let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Add comment..."
        label.textColor = UIColor.gray
        label.font = UIFont(name: "Avenir-Roman", size: 16)!// 15.0)!
        return label
    }()
    
    
    
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    
    
    
    @objc func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    
    @objc func hidePlaceholderLabel() {
        placeholderLabel.isHidden = true
    }
    

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
