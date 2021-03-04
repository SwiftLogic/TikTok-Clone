//
//  InputContainerView.swift
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
import SVProgressHUD
protocol InputAccessoryViewContainerViewDelegate: AnyObject {
    func didSelect(font: UIFont)
    func didSelect(color: UIColor)
    func didSelect(textAlignment: NSTextAlignment)
    func changeTextViewBackground(color: UIColor, newStyle: TextViewBackgroundColoringStyle)

    
}

public enum TextViewBackgroundColoringStyle : Int {
       case clearColor = 0
       case fillColor = 1
       case fillColorWithAlphaplacement = 2
   }
   
class InputAccessoryViewContainerView: UIView {
    
    //MARK: - Init
    //this how to do a custom init
    required init(currentTextViewBackgroundColoringStyle: TextViewBackgroundColoringStyle, currentTextAlignment: NSTextAlignment, initalTextViewBackgroundColor: UIColor, initalTextViewFont: UIFont) {
        self.currentTextViewBackgroundColoringStyle = currentTextViewBackgroundColoringStyle
        self.currentTextAlignment = currentTextAlignment
        self.initalTextViewBackgroundColor = initalTextViewBackgroundColor
        self.initalTextViewFont = initalTextViewFont
        super.init(frame: CGRect.zero)
        setUpViews()
    }
    
    
    
    //MARK: - Properties

    weak var delegate: InputAccessoryViewContainerViewDelegate?
    fileprivate var currentTextAlignment: NSTextAlignment //= .center
    fileprivate var currentTextViewBackgroundColoringStyle: TextViewBackgroundColoringStyle //= .clearColor
    fileprivate var initalTextViewBackgroundColor: UIColor
    fileprivate var initalTextViewFont: UIFont

    fileprivate var currentColor: UIColor = .white

    
    fileprivate lazy var colorsCollectionView: ColorsCollectionView = {
        let view = ColorsCollectionView(selectedColor: self.initalTextViewBackgroundColor)
        view.delegate = self
        return view
    }()
    
    
    fileprivate lazy var fontsCollectionView: FontsCollectionView = {
        let view = FontsCollectionView(selectedFont: self.initalTextViewFont)//UIFont.boldSystemFont(ofSize: 15))
        view.delegate = self
        return view
    }()
    
    fileprivate let backgroundChangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("A", for: .normal)
        button.titleLabel?.font = defaultFont(size: 17)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapChangeBackgroundColor), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    
    fileprivate let textAlignMentButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setImage(alightCenter_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapChangeTextAlignment), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate let verticalLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        return view
    }()
    
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    
    
    
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(colorsCollectionView)
        colorsCollectionView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 55))
        
        
        addSubview(backgroundChangeButton)
        backgroundChangeButton.anchor(top: nil, leading: leadingAnchor, bottom: colorsCollectionView.topAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 7, right: 0), size: .init(width: 23.5, height: 23.5))
        
        
        addSubview(textAlignMentButton)
        textAlignMentButton.anchor(top: nil, leading: backgroundChangeButton.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 7, right: 0), size: .init(width: 30, height: 30))
        textAlignMentButton.centerYAnchor.constraint(equalTo: backgroundChangeButton.centerYAnchor).isActive = true
        
        
        addSubview(verticalLineSeperatorView)
        verticalLineSeperatorView.anchor(top: backgroundChangeButton.topAnchor, leading: textAlignMentButton.trailingAnchor, bottom: backgroundChangeButton.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 0.5, height: 0))
        
        
        addSubview(fontsCollectionView)
        fontsCollectionView.anchor(top: nil, leading: verticalLineSeperatorView.trailingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 55))
        fontsCollectionView.centerYAnchor.constraint(equalTo: verticalLineSeperatorView.centerYAnchor).isActive = true
              
        
        handleSetUpUI()
        
        
               
    }
    
    
    
    fileprivate func handleSetUpUI() {
   //default background color
        handleSetUpInitialBackgroundButtonColor()
       
        //default textalignment
        if currentTextAlignment == .center {
            textAlignMentButton.setImage(alightCenter_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
            
        } else if currentTextAlignment == .left {
            textAlignMentButton.setImage(alightLeft_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
            
        } else if currentTextAlignment == .right {
            textAlignMentButton.setImage(alightRight_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
            
        }

    }
    
    
    
    fileprivate func handleSetUpInitialBackgroundButtonColor() {
           if currentTextViewBackgroundColoringStyle == .clearColor {
               backgroundChangeButton.backgroundColor = UIColor.clear
               backgroundChangeButton.setTitleColor(.white, for: .normal)
               backgroundChangeButton.layer.borderWidth = 2
               backgroundChangeButton.layer.borderColor = UIColor.white.cgColor
               
           } else if currentTextViewBackgroundColoringStyle == .fillColor {
               backgroundChangeButton.backgroundColor = .white
               backgroundChangeButton.setTitleColor(.black, for: .normal)
               backgroundChangeButton.layer.borderWidth = 0
               
           } else if currentTextViewBackgroundColoringStyle == .fillColorWithAlphaplacement {
               backgroundChangeButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
               backgroundChangeButton.setTitleColor(.white, for: .normal)
               backgroundChangeButton.layer.borderWidth = 0
           }
       }
    
    //MARK: - Target Selectors
    @objc fileprivate func didTapChangeBackgroundColor(button: UIButton) {
        if button.backgroundColor == .clear {
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 0
            currentTextViewBackgroundColoringStyle = .fillColor
            didSelect(color: currentColor)
        } else if button.backgroundColor == .white {
            button.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 0
            currentTextViewBackgroundColoringStyle = .fillColorWithAlphaplacement
            didSelect(color: currentColor)

        } else if button.backgroundColor == UIColor.white.withAlphaComponent(0.4){
            button.backgroundColor = UIColor.clear
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
            currentTextViewBackgroundColoringStyle = .clearColor
            delegate?.changeTextViewBackground(color: .clear, newStyle: .clearColor)
            didSelect(color: currentColor)
        }
    }
    
    
   
    
    
    
    @objc fileprivate func didTapChangeTextAlignment() {
        if currentTextAlignment == .center {
            textAlignMentButton.setImage(alightLeft_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
            delegate?.didSelect(textAlignment: .left)
            currentTextAlignment = .left
        } else if currentTextAlignment == .left {
            textAlignMentButton.setImage(alightRight_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
            delegate?.didSelect(textAlignment: .right)
            currentTextAlignment = .right

        } else if currentTextAlignment == .right {
            textAlignMentButton.setImage(alightCenter_ic?.withRenderingMode(.alwaysTemplate), for: .normal)
            delegate?.didSelect(textAlignment: .center)
            currentTextAlignment = .center
        }
    }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2021 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - FontsCollectionViewDelegate & ColorsCollectionViewDelegate
extension InputAccessoryViewContainerView: FontsCollectionViewDelegate, ColorsCollectionViewDelegate {
    
    func didSelect(font: UIFont) {
        delegate?.didSelect(font: font)
    }
    
    
    func didSelect(color: UIColor) {
        currentColor = color
        if currentTextViewBackgroundColoringStyle == .clearColor {
            delegate?.didSelect(color: color)
        } else if currentTextViewBackgroundColoringStyle == .fillColor {
            delegate?.changeTextViewBackground(color: color, newStyle: .fillColor)
            
        } else if currentTextViewBackgroundColoringStyle == .fillColorWithAlphaplacement {
            delegate?.changeTextViewBackground(color: color.withAlphaComponent(0.5), newStyle: .fillColorWithAlphaplacement)
        }
    }
    
}
