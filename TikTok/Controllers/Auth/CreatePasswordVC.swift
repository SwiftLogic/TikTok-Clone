//
//  CreatePasswordVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class CreatePasswordVC: UIViewController, UITextFieldDelegate {
    
    //MARK: Init
    init(birthdate: Date, emailAddress: String) {
        self.birthdate = birthdate
        self.emailAddress = emailAddress
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
    fileprivate let emailAddress: String
    
    fileprivate let createPasswordLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.text = "Create Password"
        label.font = defaultFont(size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = tikTokRed
        tf.attributedPlaceholder = NSAttributedString(string: "Enter Password", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: avenirRomanFont(size: 14.5)
        ])
        tf.addTarget(self, action: #selector(handleValidateNextButton), for: .editingChanged)
        tf.isSecureTextEntry = true
        tf.delegate = self
        return tf
    }()
    
    
    fileprivate let lineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
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
        button.addTarget(self, action: #selector(handleAuthenticateUser), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    
    fileprivate let yourPasswordMustHaveLabel: UILabel = {
          let label = UILabel()
           label.textColor = .black
           label.text = "Your password must have:"
        label.font = defaultFont(size: 12.5)
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    
    fileprivate let passwordCharLimitlabel: UILabel = {
         let label = UILabel()
         label.textColor = .lightGray
         label.text = "8 to 20 characters"
         label.font = avenirRomanFont(size: 12)
         label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    
    fileprivate let passwordMustContainlabel: UILabel = {
       let label = UILabel()
       label.textColor = .lightGray
       label.text = "Letters, numbers, and special characters"
       label.font = avenirRomanFont(size: 12)
       label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    fileprivate let firstIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = unselectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    
    
    fileprivate let secondIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = unselectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    
    
    
    fileprivate let captchaVerificationView: CaptchaVerificationView = {
        let captchaVerificationView = CaptchaVerificationView()
        return captchaVerificationView
    }()
    
    
    
    
    //MARK: - Handlers
    fileprivate func handleSetUpNavItems() {
        navigationItem.title = "Sign up"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    
    fileprivate func setUpViews() {
        view.addSubview(createPasswordLabel)
        
        createPasswordLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0))
        
        view.addSubview(passwordTextField)
        passwordTextField.anchor(top: createPasswordLabel.bottomAnchor, leading: createPasswordLabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 45, left: 0, bottom: 0, right: 20), size: .init(width: 0, height: 40))

        
        view.addSubview(lineSeperatorView)
        lineSeperatorView.anchor(top: passwordTextField.bottomAnchor, leading: passwordTextField.leadingAnchor, bottom: nil, trailing: passwordTextField.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.8))
        
        view.addSubview(yourPasswordMustHaveLabel)
        yourPasswordMustHaveLabel.anchor(top: lineSeperatorView.bottomAnchor, leading: lineSeperatorView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        
        
        view.addSubview(firstIcon)
        firstIcon.anchor(top: yourPasswordMustHaveLabel.bottomAnchor, leading: yourPasswordMustHaveLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 7, left: 0, bottom: 0, right: 0), size: .init(width: 14.5, height: 14.5))
        
        
        view.addSubview(secondIcon)
        secondIcon.anchor(top: firstIcon.bottomAnchor, leading: yourPasswordMustHaveLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 7, left: 0, bottom: 0, right: 0), size: .init(width: 14.5, height: 14.5))
        
        
        view.addSubview(passwordCharLimitlabel)
        passwordCharLimitlabel.centerYAnchor.constraint(equalTo: firstIcon.centerYAnchor, constant: 1).isActive = true
        passwordCharLimitlabel.leadingAnchor.constraint(equalTo: firstIcon.trailingAnchor, constant: 4).isActive = true
        
        
        view.addSubview(passwordMustContainlabel)
        passwordMustContainlabel.centerYAnchor.constraint(equalTo: secondIcon.centerYAnchor, constant: 1).isActive = true
        passwordMustContainlabel.leadingAnchor.constraint(equalTo: secondIcon.trailingAnchor, constant: 4).isActive = true
        
        
        view.addSubview(nextButton)
        nextButton.anchor(top: secondIcon.bottomAnchor, leading: lineSeperatorView.leadingAnchor, bottom: nil, trailing: lineSeperatorView.trailingAnchor, padding: .init(top: 35, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
               
        
        let blackview = UIView()
        blackview.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.addSubview(blackview)
        blackview.fillSuperview()
        view.addSubview(captchaVerificationView)
        let spacing: CGFloat = view.frame.width * 0.12
        captchaVerificationView.centerInSuperview(size: .init(width: view.frame.width - spacing, height: view.frame.width - spacing))
//
    }
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func handleValidateNextButton() {
           let isValid = passwordTextField.text?.count ?? 0 > 0 ? true : false
           if isValid == false {
               nextButton.isEnabled = false
               nextButton.backgroundColor = baseWhiteColor
               nextButton.setTitleColor(.gray, for: .normal)
           } else {
               nextButton.isEnabled = true
               nextButton.backgroundColor = tikTokRed
               nextButton.setTitleColor(.white, for: .normal)
               handleValidatePassWordChars()
           }
       }
    
    
    fileprivate func handleValidatePassWordChars() {
        let charPropertiesIsValid = passwordTextField.text?.count ?? 0 > 8 ? true : false
        
        if charPropertiesIsValid == true {
            passwordCharLimitlabel.textColor = tikTokRed//.black
            firstIcon.image = selectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
            firstIcon.tintColor = tikTokRed
        } else {
            passwordCharLimitlabel.textColor = .lightGray
            firstIcon.image = unselectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
            firstIcon.tintColor = .lightGray
        }
        
        
        
        guard let text = passwordTextField.text else {return}
        if hasSpecialCharacters(text: text) == true {
            passwordMustContainlabel.textColor = tikTokRed//.black
            secondIcon.image = selectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
            secondIcon.tintColor = tikTokRed
        } else {
            passwordMustContainlabel.textColor = .lightGray
            secondIcon.image = unselectedMediaCheckIcon?.withRenderingMode(.alwaysTemplate)
            secondIcon.tintColor = .lightGray
        }
    }
    
    
    
    func hasSpecialCharacters(text: String) -> Bool {

        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: text, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, text.count)) {
                return true
            }

        } catch {
            debugPrint(error.localizedDescription)
            return false
        }

        return false
    }
    
    
    
    @objc fileprivate func handleAuthenticateUser() {
        
        
        let createUsernameVC = CreateUsernameVC(birthdate: birthdate, emailAddress: emailAddress, password: passwordTextField.text ?? "")
        navigationController?.pushViewController(createUsernameVC, animated: true)
     
    }
    
    
    //Resign First Responders
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - UITextFieldDelegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
    }
}
