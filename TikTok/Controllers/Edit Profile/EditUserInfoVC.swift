//
//  EditUserInfoVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/3/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
enum UserInfoToEdit {
    case editName(String)
    case editUsername(String)
    case editBio(String)
}
class EditUserInfoVC: UIViewController {
    
    //MARK: - Init
    init(userInfoToEdit: UserInfoToEdit, user: User) {
        self.userInfoToEdit = userInfoToEdit
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavItems()
        setUpViews()
    }
    
    
    //MARK: - Properties
    fileprivate let userInfoToEdit: UserInfoToEdit
    fileprivate let user: User
    fileprivate var placeholderText = "Add your name" {
        didSet {
            textView.placeholderLabel.text = placeholderText
        }
    }
    
    fileprivate var userInfoValue: String?
    
    fileprivate lazy var textView: CommentInputTextView = {
        let textView = CommentInputTextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.tintColor = tikTokRed
        textView.placeholderLabel.textColor = .lightGray
        textView.returnKeyType = .default
//        textView.placeholderLabel.text = "Add your name"
        textView.placeholderLabel.font = avenirRomanFont(size: 14.5)
        textView.font = avenirRomanFont(size: 14.5)
        textView.delegate = self
        return textView
    }()
    
    
    fileprivate let lineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    fileprivate var maxCharCount: Int = 30
    let countlabelfont = UIFont.systemFont(ofSize: 12.5)
    fileprivate lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = countlabelfont
        label.text = "0/\(maxCharCount)"
        return label
    }()
    
    
    fileprivate let alertLabelYTranslation: CGFloat = 35
    fileprivate var isAlertlabelVisible = false
    fileprivate lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.darkGray
        label.textColor = .white
        label.font = defaultFont(size: 14.5)
        label.text = "Character limit exceeded"
        label.textAlignment = .center
        label.transform = CGAffineTransform(translationX: 0, y: -35)
        return label
    }()
    
    
    //MARK: - Handlers
    fileprivate func setUpNavItems() {
        handleConfigUI(forUserInfoToEdit: userInfoToEdit)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDidTapCancelNavItem))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: avenirRomanFont(size: 16)], for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleDidTapSaveNavItem))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: defaultFont(size: 16)], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: defaultFont(size: 16)], for: .disabled)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    
    fileprivate func setUpViews() {
        view.backgroundColor = .white
        view.addSubview(textView)
        //Summary to enable dynamic height textView with max height: Disable scrolling of your text view, and don't constraint its height.
        // textView.isScrollEnabled = false   // causes expanding height
    //set autolayout
        textView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 6, left: 17, bottom: 0, right: 17))
        view.addSubview(lineSeperatorView)
        
        let topSpacing: CGFloat = navigationItem.title == "Bio" ? 100 : 6
        lineSeperatorView.anchor(top: textView.bottomAnchor, leading: textView.leadingAnchor, bottom: nil, trailing: textView.trailingAnchor, padding: .init(top: topSpacing, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
        
        view.addSubview(countLabel)
        countLabel.anchor(top: lineSeperatorView.bottomAnchor, leading: lineSeperatorView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        textView.becomeFirstResponder()
        
        view.addSubview(alertLabel)
        alertLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 35))
    }
    
    
    func handleConfigUI(forUserInfoToEdit userInfoToEdit: UserInfoToEdit) {
        switch userInfoToEdit {
        case .editName(let navTitle):
            navigationItem.title = navTitle
            placeholderText = "Add your name"
            maxCharCount = 30
            textView.text = user.fullname
            userInfoValue = user.fullname
            
        case .editUsername(let navTitle):
            navigationItem.title = navTitle
            placeholderText = "Username"
            maxCharCount = 24
            textView.text = user.username
            userInfoValue = user.username

        case .editBio(let navTitle):
            navigationItem.title = navTitle
            placeholderText = "Add a bio to your profile"
            maxCharCount = 80
            textView.text = user.bio
            userInfoValue = user.bio

        }
        textView.placeholderLabel.text = textView.text.isEmpty == true ? placeholderText : ""
        textViewDidChange(textView)
    }
    
    
    
    @objc private func handleAnimateAlertlabel() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[weak self] in
            guard let self = self else {return}
            if self.isAlertlabelVisible {
                self.alertLabel.transform = .identity
            } else {
                self.alertLabel.transform = CGAffineTransform(translationX: 0, y: -self.alertLabelYTranslation)
            }
        } completion: { [weak self] onComplete in
            guard let self = self else {return}
            self.isAlertlabelVisible = !self.isAlertlabelVisible
            if self.isAlertlabelVisible == false {
                self.perform(#selector(self.handleAnimateAlertlabel), with: nil, afterDelay: 0.5)
            }
        }
    }
    
    
    
    @objc fileprivate func handleSave(userInfo: String) {
        guard let CURRENT_UID = CURRENT_UID else {return}
        Database.database().reference().child("users").child(CURRENT_UID).child(userInfo).setValue(textView.text) {[weak self] error, _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: - Target Selectors
    @objc fileprivate func handleDidTapCancelNavItem() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc fileprivate func handleDidTapSaveNavItem() {
        switch userInfoToEdit {
        case .editName:
            handleSave(userInfo: "fullname")
        case .editUsername:
            handleSave(userInfo: "username")
        case .editBio:
            handleSave(userInfo: "bio")
        }

    }
    
}



//MARK: - TextView Delegate
extension EditUserInfoVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        switch userInfoToEdit {
        case .editName:
            break
        case .editUsername:
            let sanitizedText = handleSanitize(input: textView.text)
            textView.text = sanitizedText
        case .editBio:
            break
        }
        
        let charCount = textView.text.count
        self.textView.placeholderLabel.text = textView.text.isEmpty == true ? placeholderText : ""
        countLabel.text = "\(charCount)/\(maxCharCount)"
        
        if charCount != 0 && textView.text != userInfoValue {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        if charCount == maxCharCount {
            countLabel.attributedText = setupAttributedTextWithFonts(titleString: "\(charCount)/", subTitleString: "\(maxCharCount)", attributedTextColor: .gray, mainColor: tikTokRed, mainfont: countlabelfont, subFont: countlabelfont)
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let charCount = textView.text.count
        guard charCount < maxCharCount else {
            //            print("DEBUG: MAX CHAR COUNT")
            if text.count == 0 && range.length > 0 {
                // Back pressed
                //                print("DEBUG: Back pressed")
                return true
            }
            handleAnimateAlertlabel()
            return false
        }
        
        if text == "\n" { // return button was pressed
            switch userInfoToEdit {
            case .editUsername: return false
            default: return true
            }
        }
        return true
    }
    
   
    
    
}
