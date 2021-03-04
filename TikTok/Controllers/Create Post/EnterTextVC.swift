//
//  EnterTextVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol EnterTextVCDelegate: class {
    func enterTextVCWillDisappear()
    func addNewStickerToView(stickerText: String, textColor: UIColor, textAlignment: NSTextAlignment, stickerBackgroundColor: UIColor, stickerFont: UIFont, currentBackgroundColorStyle: TextViewBackgroundColoringStyle)
}
class EnterTextVC: UIViewController, UITextViewDelegate {
    
    //MARK: Init
    
    init(stickerText: String = "", stickerFont: UIFont = defaultFont(size: textViewFontSize), stickerBackgroundColor: UIColor = .clear, textAlignment: NSTextAlignment = .center, stickerTextColor: UIColor = .white, currentTextViewBackgroundColoringStyle: TextViewBackgroundColoringStyle = .clearColor) {
        self.stickerText = stickerText
        self.currentFont = stickerFont
        self.stickerBackgroundColor = stickerBackgroundColor
        self.currentTextAlignment = textAlignment
        self.stickerTextColor = stickerTextColor
        self.currentTextViewBackgroundColoringStyle = currentTextViewBackgroundColoringStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View LifeCycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.enterTextVCWillDisappear()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doneButton.alpha = 1
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
//        setUpTapGesture()
    }
    
    
    //MARK: - Properties
    fileprivate var stickerText: String?

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    weak var delegate: EnterTextVCDelegate?

    //MARK: - Observers
    private var isOversized = false {
        didSet {
            //this prevents observer from triggering multiple times
            guard oldValue != isOversized else {
                return
            }
            
            textView.isScrollEnabled = isOversized
            textView.setNeedsUpdateConstraints()
        }
    }
    
    fileprivate var currentTextAlignment: NSTextAlignment = .center {
        didSet {
            guard oldValue != currentTextAlignment else {return}
            textView.textAlignment = currentTextAlignment
            setHighlightPath()
        }
    }
    
    fileprivate var currentFont: UIFont  {
        didSet {
            guard oldValue != currentFont else {return}
            textView.font = currentFont
            setHighlightPath()
        }
    }
    
    
    var stickerBackgroundColor: UIColor = .clear {
        
           didSet {
           highlightLayer.fillColor = stickerBackgroundColor.cgColor
           textView.backgroundColor = .clear
            
            if stickerBackgroundColor == .clear {
                
            highlightLayer.fillColor = UIColor.clear.cgColor
            textView.backgroundColor = .clear
        
        
              } else if stickerBackgroundColor == .white {
                  stickerTextColor = .black
                  highlightLayer.fillColor = UIColor.white.cgColor
                  textView.backgroundColor = .clear
                  
              } else {
                  stickerTextColor = .white
                  highlightLayer.fillColor = stickerBackgroundColor.cgColor
                  textView.backgroundColor = .clear
              }
           }
       }

    
    
    
    
    fileprivate var stickerTextColor: UIColor {
        didSet {
            textView.textColor = stickerTextColor
        }
    }

    
    
    private var highlightLayer = CAShapeLayer()
    fileprivate var currentTextViewBackgroundColoringStyle: TextViewBackgroundColoringStyle


    
    fileprivate let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = defaultFont(size: 17)
        button.addTarget(self, action: #selector(didSelectDoneButton), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    
    fileprivate lazy var inputAccessoryViewContainerView: InputAccessoryViewContainerView = {
        var initalTextViewBackgroundColor: UIColor
        if self.currentTextViewBackgroundColoringStyle == .clearColor {
            initalTextViewBackgroundColor = self.stickerTextColor
        } else if self.currentTextViewBackgroundColoringStyle == .fillColor {
            initalTextViewBackgroundColor = self.stickerBackgroundColor
        } else {
            initalTextViewBackgroundColor = self.stickerBackgroundColor.withAlphaComponent(1)
        }
        
        let view = InputAccessoryViewContainerView(currentTextViewBackgroundColoringStyle: self.currentTextViewBackgroundColoringStyle, currentTextAlignment: self.currentTextAlignment, initalTextViewBackgroundColor: initalTextViewBackgroundColor, initalTextViewFont: self.currentFont)
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 80)
        view.delegate = self
       return view
   }()

    
    fileprivate let textViewContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    
   fileprivate lazy var textView: UITextView = {
        let textView = UITextView()
//        textView.font = defaultFont(size: 25)
//        textView.textColor = .white
        textView.tintColor = tikTokRed
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.autocorrectionType = .no
        textView.textAlignment = .center
        textView.text = ""
        textView.delegate = self
        textView.isScrollEnabled = false
        return textView
    }()

        
  
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        view.addSubview(doneButton)
        doneButton.constrainToTop(paddingTop: 16)
        doneButton.constrainToRight(paddingRight: -16)
        
        view.addSubview(textViewContainerView)
        textViewContainerView.anchor(top: doneButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.width - 100))
                
        textViewContainerView.addSubview(textView)
        
        //Summary to enable dynamic height textView with max height: Disable scrolling of your text view, and don't constraint its height.

       // textView.isScrollEnabled = false   // causes expanding height
        //set autolayout

        textView.anchor(top: textViewContainerView.topAnchor, leading: textViewContainerView.leadingAnchor, bottom: nil, trailing: textViewContainerView.trailingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 20))
        
        textView.text = stickerText
        textView.font = currentFont
        textView.textAlignment = currentTextAlignment
        textView.textColor = stickerTextColor
        textView.becomeFirstResponder()
        perform(#selector(handleChangeTextViewToFreeStyle), with: nil, afterDelay: 0.5)

    }
    
    
    
    fileprivate func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectDoneButton))
        view.addGestureRecognizer(tapGesture)
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
    
    
    
    @objc func handleChangeTextViewToFreeStyle() {
            handleSetUpShapeLayer()
            highlightLayer.fillColor = stickerBackgroundColor.cgColor
            textView.backgroundColor = .clear
            setHighlightPath()
       }
    
    
    func handleSetUpShapeLayer() {
            highlightLayer.backgroundColor = nil
            highlightLayer.fillColor = stickerBackgroundColor.cgColor
            highlightLayer.strokeColor = nil
            textView.layer.insertSublayer(highlightLayer, at: 0)
       }
    
    
    
    
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func didSelectDoneButton() {
        delegate?.addNewStickerToView(stickerText: textView.text, textColor: textView.textColor!, textAlignment: currentTextAlignment, stickerBackgroundColor: stickerBackgroundColor, stickerFont: currentFont, currentBackgroundColorStyle: currentTextViewBackgroundColoringStyle)
        dismiss(animated: false, completion: nil)
    }
    
    
    
    //MARK: TextView Delegates
       func textViewDidChange(_ textView: UITextView) {
        let maxHeight: CGFloat = textViewContainerView.frame.height - 20
        isOversized = textView.contentSize.height > maxHeight
        setHighlightPath()
    }
       

    
    
   
   //MARK: - InputAccesoryView

      override var inputAccessoryView: UIView? {
             get {
                 return inputAccessoryViewContainerView
             }
           }


         override var canBecomeFirstResponder: Bool {
             return true
         }
        

}


//MARK: - InputAccessoryViewContainerViewDelegate
extension EnterTextVC: InputAccessoryViewContainerViewDelegate {
    
    
    func didSelect(color: UIColor) {
        stickerTextColor = color
    }
    
    func didSelect(font: UIFont) {
//        guard let newFont = UIFont(name: font.fontName, size: textView.font!.pointSize) else {return}
//        textView.font = newFont
//        currentFont = newFont
//        setHighlightPath()
        currentFont = font
    }
    
    
    func didSelect(textAlignment: NSTextAlignment) {
//        textView.textAlignment = textAlignment
//        currentTextAlignment = textAlignment
//        setHighlightPath()
        currentTextAlignment = textAlignment

    }
    
    func changeTextViewBackground(color: UIColor, newStyle: TextViewBackgroundColoringStyle) {
        stickerBackgroundColor = color
        self.currentTextViewBackgroundColoringStyle = newStyle

    }
    
}
