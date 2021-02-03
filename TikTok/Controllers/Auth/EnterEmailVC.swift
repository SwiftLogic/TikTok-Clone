//
//  EnterEmailVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
class EnterEmailVC: UIViewController {
    
    //MARK: Init
    
    init(birthdate: Date) {
        self.birthdate = birthdate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        handleSetUpNavItems()
        
    }
    
    
    //MARK: - Properties
    fileprivate let birthdate: Date

    fileprivate let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = defaultFont(size: 16.5)
        label.textAlignment = .center
        return label
    }()
    
    
    fileprivate let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone"
        label.font = defaultFont(size: 16.5)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    
    fileprivate let topLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
        return view
    }()
    
    
    fileprivate let blackViewUnderEmail: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    fileprivate let emailTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = tikTokRed
        tf.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: avenirRomanFont(size: 14.5)
        ])
        tf.addTarget(self, action: #selector(handleValidateNextButton), for: .editingChanged)
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    
    fileprivate let bottomLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    
    
    fileprivate let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = defaultFont(size: 14.5)
        button.backgroundColor = baseWhiteColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleDidSelectNextButton), for: .touchUpInside)
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
    fileprivate func handleSetUpNavItems() {
        navigationItem.title = "Sign up"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    
    fileprivate func setUpViews() {
        
        
        let stackView = UIStackView(arrangedSubviews: [phoneLabel, emailLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 40))
        
        view.addSubview(topLineSeperatorView)
        topLineSeperatorView.anchor(top: stackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 0.8))
        
        view.addSubview(blackViewUnderEmail)
        blackViewUnderEmail.anchor(top: topLineSeperatorView.topAnchor, leading: emailLabel.leadingAnchor, bottom: nil, trailing: emailLabel.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 2.5))
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: blackViewUnderEmail.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 40))
        
        
        view.addSubview(bottomLineSeperatorView)
        bottomLineSeperatorView.anchor(top: emailTextField.bottomAnchor, leading: emailTextField.leadingAnchor, bottom: nil, trailing: emailTextField.trailingAnchor, size: .init(width: 0, height: 0.5))
        
        
        
        view.addSubview(nextButton)
        nextButton.anchor(top: bottomLineSeperatorView.bottomAnchor, leading: bottomLineSeperatorView.leadingAnchor, bottom: nil, trailing: bottomLineSeperatorView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        
        
        view.addSubview(termsOfServiceLabel)
        termsOfServiceLabel.anchor(top: nextButton.bottomAnchor, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
        
        
        let termsOffServiceAttributedString = setupAttributedTextWithFonts(titleString: "By Signing up, you certify that you have read and that you understand and agree to be bounded by our ", subTitleString: "Terms of Service and Privacy Policy", attributedTextColor: .black, mainColor: .gray, mainfont: avenirRomanFont(size: 13.5), subFont: .boldSystemFont(ofSize: 12.5))
        
            termsOfServiceLabel.attributedText = termsOffServiceAttributedString
        
        emailTextField.becomeFirstResponder()
        
      
    }
    
    
    
    
    @objc fileprivate func handleDidSelectNextButton() {
        let createPasswordVC = CreatePasswordVC(birthdate: birthdate, emailAddress: emailTextField.text ?? "")
        navigationController?.pushViewController(createPasswordVC, animated: true)
    }
    
    
    
    @objc fileprivate func handleValidateNextButton() {
        let isValid = emailTextField.text?.count ?? 0 > 0 ? true : false
        if isValid == false {
            nextButton.isEnabled = false
            nextButton.backgroundColor = baseWhiteColor
            nextButton.setTitleColor(.gray, for: .normal)
        } else {
            nextButton.isEnabled = true
            nextButton.backgroundColor = tikTokRed
            nextButton.setTitleColor(.white, for: .normal)
        }
    }
    
}
