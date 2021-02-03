//
//  AuthViewController.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
enum AuthType {
    case signUp
    case signIn
}
class AuthViewController: UIViewController {
    
    //MARK: Init
    
    
    init(authType: AuthType) {
        self.authType = authType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handleSetUpNavItems()
        setUpViews()
        handleSetUpUpLabelAttributedStrings()
        handleSetUpTargetSelectors()
    }
    
    
    
   
    
    //MARK: - Properties
    fileprivate let authType: AuthType
    
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    
    fileprivate let signUpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate lazy var phoneOrEmailButton = handleCreateButton(title: authType == .signUp ? "Use phone or email" : "Use phone / email / username")
    fileprivate lazy var facebookButton = handleCreateButton(title: "Continue with Facebook")
    fileprivate lazy var appleButton = handleCreateButton(title: "Continue with Apple")
    fileprivate lazy var googleButton = handleCreateButton(title: "Continue with Google")
    fileprivate lazy var twitterButton = handleCreateButton(title: "Continue with Twitter")

    

    
    fileprivate let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = baseWhiteColor
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.titleLabel?.font = defaultFont(size: 14.5)
        button.addTarget(self, action: #selector(handleDidTapSignButton), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate let termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        view.addSubview(signUpLabel)
                
        let toppading = handleCalCulateTopPadding()//view.frame.height * 0.21
        signUpLabel.constrainToTop(paddingTop: toppading)
        signUpLabel.constrainToLeft(paddingLeft: 12)
        signUpLabel.constrainToRight(paddingRight: -12)
        
        
        let stackView = UIStackView(arrangedSubviews: [phoneOrEmailButton, facebookButton, appleButton, googleButton, appleButton, twitterButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
    
        view.addSubview(stackView)
        stackView.anchor(top: signUpLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 265))
        
        
        view.addSubview(termsOfServiceLabel)
        termsOfServiceLabel.anchor(top: stackView.bottomAnchor, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
        
        
        view.addSubview(signInButton)
        signInButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 55))
        
        handleSetUpButtonIcons(insertInside: phoneOrEmailButton, image: smalluserIcon)
        handleSetUpButtonIcons(insertInside: facebookButton, image: smallfacebookIcon)
        handleSetUpButtonIcons(insertInside: googleButton, image: googleIcon)
        handleSetUpButtonIcons(insertInside: twitterButton, image: twitterIcon)
        handleSetUpButtonIcons(insertInside: appleButton, image: appleIcon)
        

    }
    
    
    fileprivate func handleSetUpNavItems() {
        navigationItem.hidesBackButton = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        handleHide_ShowNavLine(navController: navigationController, showLine: false)
    }
    
    
    fileprivate func handleSetUpUpLabelAttributedStrings() {
        let signUpLabelTitleText = authType == .signUp ? "Sign up for TikTok\n\n" : "Log in to TikTok\n\n"
        
        let signUpLabelsubTitleString = authType == .signUp ? "Create a profile, follow other accounts, make your own videos, and more." : "Manage your account, check notifications, comment on videos, and more."
        let attributedString = setupAttributedTextWithFonts(titleString: signUpLabelTitleText, subTitleString: signUpLabelsubTitleString, attributedTextColor: .gray, mainColor: .black, mainfont: defaultFont(size: 20), subFont: avenirRomanFont(size: 14))
        signUpLabel.attributedText = attributedString
        
        
        
        
        let termsOffServiceAttributedString = setupAttributedTextWithFonts(titleString: "By Signing up, you certify that you have read and that you understand and agree to be bounded by our ", subTitleString: "Terms of Service and Privacy Policy", attributedTextColor: .black, mainColor: .gray, mainfont: avenirRomanFont(size: 11.5), subFont: .boldSystemFont(ofSize: 10.5))
        
        if authType == .signUp {
            termsOfServiceLabel.attributedText = termsOffServiceAttributedString
        }
        
        
        
        let signInButtonTitleText = authType == .signUp ? "Already have an account? " : "Don't have an account? "
        
        let signInButtonsubTitleString = authType == .signUp ? "Log in" : "Sign up"
        
        let signInButtonAttributedString = setupAttributedTextWithFonts(titleString: signInButtonTitleText, subTitleString: signInButtonsubTitleString, attributedTextColor: tikTokRed, mainColor: .black, mainfont: avenirRomanFont(size: 14.5), subFont: .boldSystemFont(ofSize: 14.5))
        signInButton.setAttributedTitle(signInButtonAttributedString, for: .normal)
        
    }
    
    
    fileprivate func handleCreateButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.titleLabel?.font = defaultFont(size: 14.5)
        button.layer.borderWidth = 0.8
        button.layer.borderColor = baseWhiteColor.cgColor
        return button
    }
    
    
    fileprivate func handleSetUpButtonIcons(insertInside superView: UIView, image: UIImage?) {
        let iconImageView = UIImageView()
        iconImageView.image = image
        superView.addSubview(iconImageView)
        iconImageView.centerYInSuperview()
        iconImageView.constrainWidth(constant: 20)
        iconImageView.constrainHeight(constant: 20)
        iconImageView.constrainToLeft(paddingLeft: 14)
    }
    
    
    
    
    
    //MARK: - Target Selectors
    
    
    @objc fileprivate func handleSetUpTargetSelectors() {
        if authType == .signUp {
            phoneOrEmailButton.addTarget(self, action: #selector(handleNavigateToNextVC), for: .touchUpInside)
        }
    }
    
    @objc fileprivate func handleDidTapSignButton() {
        if authType == .signUp {
            let authViewController = AuthViewController(authType: .signIn)
            navigationController?.pushViewController(authViewController, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc fileprivate func handleNavigateToNextVC() {
        let birthdayVC = BirthdayVC()
        navigationController?.pushViewController(birthdayVC, animated: true)
    }
    
    
    
    @objc fileprivate func handleLogIn() {

    }
    
    
    @objc fileprivate func handleSignUp() {
        
    }
    
    
    
    
    
    
}


extension AuthViewController {
    func handleCalCulateTopPadding() -> CGFloat {
                 var defaultHeight: CGFloat  = view.frame.height * 0.21
                     if UIDevice().userInterfaceIdiom == .phone {
                         switch UIScreen.main.nativeBounds.height {
                         case 1136:
                            defaultHeight = view.frame.height * 0.11
                             //                print("iPhone 5 or 5S or 5C")
             
             
                         case 1334:
//                             defaultHeight = defaultHeight
                                             print("iPhone 6/6S/7/8")
             
                         case 1920, 2208:
//                             defaultHeight = defaultHeight
                                             print("iPhone 6+/6S+/7+/8+")
             
                         case 2436:
//                             defaultHeight = defaultHeight
                                             print("iPhone X/XS/11 Pro")
             
                         case 2688:
//                             defaultHeight = defaultHeight
                                             print("iPhone XS Max/11 Pro Max")
             
                         case 1792:
//                             defaultHeight = defaultHeight
                                             print("iPhone XR/ 11 ")
             
                         default:
//                             defaultHeight = defaultHeight
                                             print("Unknown")
                         }
                     }
             
                     return defaultHeight
         }
         
}



