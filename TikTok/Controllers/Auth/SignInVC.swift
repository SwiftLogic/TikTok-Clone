//
//  SignInVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class SignInVC: UIViewController, UITextFieldDelegate {
    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        
    }
    
    
    //MARK: - Properties
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
    
    
    fileprivate lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = tikTokRed
        tf.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: avenirRomanFont(size: 14.5)
        ])
        tf.addTarget(self, action: #selector(handleValidateNextButton), for: .editingChanged)
        tf.keyboardType = .emailAddress
        tf.delegate = self
        return tf
    }()
    
    
    
    fileprivate lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = tikTokRed
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: avenirRomanFont(size: 14.5)
        ])
        tf.addTarget(self, action: #selector(handleValidateNextButton), for: .editingChanged)
        tf.isSecureTextEntry = true
        tf.delegate = self
        return tf
    }()
    
    
    fileprivate let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Forgot password?", for: .normal)
        button.titleLabel?.font = defaultFont(size: 14.5)
        return button
    }()
    
    
    
    fileprivate let emailTFbottomLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    
    fileprivate let passwordTFbottomLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    
    
    fileprivate let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = defaultFont(size: 14.5)
        button.backgroundColor = baseWhiteColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleDidTapLogInButton), for: .touchUpInside)
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
        emailTextField.anchor(top: blackViewUnderEmail.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 40))
        
        
        
        view.addSubview(emailTFbottomLineSeperatorView)
        emailTFbottomLineSeperatorView.anchor(top: emailTextField.bottomAnchor, leading: emailTextField.leadingAnchor, bottom: nil, trailing: emailTextField.trailingAnchor, size: .init(width: 0, height: 0.5))
        
        
        
        view.addSubview(passwordTextField)
        passwordTextField.anchor(top: emailTFbottomLineSeperatorView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 30, bottom: 0, right: 30), size: .init(width: 0, height: 40))
        
        
        
        view.addSubview(passwordTFbottomLineSeperatorView)
        passwordTFbottomLineSeperatorView.anchor(top: passwordTextField.bottomAnchor, leading: emailTextField.leadingAnchor, bottom: nil, trailing: emailTextField.trailingAnchor, size: .init(width: 0, height: 0.5))
             
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: passwordTFbottomLineSeperatorView.bottomAnchor, leading: passwordTFbottomLineSeperatorView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 0, bottom: 0, right: 0))
             
        
        view.addSubview(logInButton)
        logInButton.anchor(top: forgotPasswordButton.bottomAnchor, leading: emailTFbottomLineSeperatorView.leadingAnchor, bottom: nil, trailing: emailTFbottomLineSeperatorView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        
        
      
        emailTextField.becomeFirstResponder()
        
      
    }
    
    
    
    
    @objc fileprivate func handleDidTapLogInButton() {
       
        guard let email = emailTextField.text else {
            SVProgressHUD.showError(withStatus: "Please enter a valid email")
            SVProgressHUD.dismiss(withDelay: 2.0)
            return}
        
        
        guard let password = passwordTextField.text else {
            SVProgressHUD.showError(withStatus: "Please enter a valid password")
            SVProgressHUD.dismiss(withDelay: 2.0)
            return }
        
        logInButton.isEnabled = false
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] (authResult, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 2.0)
                self?.logInButton.isEnabled = true
                return
            }
            self?.uponSignInCompletion()

        }
    }
    
    
    @objc fileprivate func uponSignInCompletion() {
        let mainTabbarVC = MainTabBarController()
        mainTabbarVC.modalPresentationStyle = .fullScreen
        present(mainTabbarVC, animated: true) {
            SVProgressHUD.showSuccess(withStatus: "Welcome Back To TikTok")
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.dismiss(withDelay: 3.0)
        }
    }
    
    
    
    @objc fileprivate func handleValidateNextButton() {
        let emailIsValid = emailTextField.text?.count ?? 0 > 0 ? true : false
        let passwordIsValid = passwordTextField.text?.count ?? 0 > 0 ? true : false

        if emailIsValid == false || passwordIsValid == false {
            logInButton.isEnabled = false
            logInButton.backgroundColor = baseWhiteColor
            logInButton.setTitleColor(.gray, for: .normal)
        } else {
            logInButton.isEnabled = true
            logInButton.backgroundColor = tikTokRed
            logInButton.setTitleColor(.white, for: .normal)
        }
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
