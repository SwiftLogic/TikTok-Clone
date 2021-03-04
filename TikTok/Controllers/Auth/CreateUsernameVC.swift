//
//  CreateUsernameVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class CreateUsernameVC: UIViewController {
    
    //MARK: Init
    init(birthdate: Date, emailAddress: String, password: String) {
        self.birthdate = birthdate
        self.emailAddress = emailAddress
        self.password = password
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Lidecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handleSetUpNavItems()
        setUpViews()
        
    }
    
    
    //MARK: - Properties
    fileprivate let birthdate: Date
    fileprivate let emailAddress: String
    fileprivate let password: String
    
    fileprivate let usernameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = setupAttributedTextWithFonts(titleString: "Create username\n", subTitleString: "You can always change this later.", attributedTextColor: .gray, mainColor: .black, mainfont: defaultFont(size: 20), subFont: .systemFont(ofSize: 12.5))
       label.attributedText = attributedString
        return label
    }()
    
    
    
    fileprivate let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.tintColor = tikTokRed
        tf.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: avenirRomanFont(size: 14.5)
        ])
        tf.addTarget(self, action: #selector(handleValidateNextButton), for: .editingChanged)
        return tf
    }()
    
    
    fileprivate let bottomLineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    
    
    fileprivate let signUpButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Sign Up", for: .normal)
       button.setTitleColor(.gray, for: .normal)
       button.titleLabel?.font = defaultFont(size: 14.5)
       button.backgroundColor = baseWhiteColor
       button.clipsToBounds = true
       button.layer.cornerRadius = 3
       button.isEnabled = false
       button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
       return button
   }()
    
    
    
    //MARK: - Handlers
    fileprivate func handleSetUpNavItems() {
        navigationItem.title = "Sign up"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .gray
    }
    
    
    fileprivate func setUpViews() {
        view.addSubview(usernameLabel)
        
        usernameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0))
        
        
        
        view.addSubview(usernameTextField)
       usernameTextField.anchor(top: usernameLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 40))
       
               
       view.addSubview(bottomLineSeperatorView)
       bottomLineSeperatorView.anchor(top: usernameTextField.bottomAnchor, leading: usernameTextField.leadingAnchor, bottom: nil, trailing: usernameTextField.trailingAnchor, size: .init(width: 0, height: 0.5))
       
        
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: bottomLineSeperatorView.bottomAnchor, leading: bottomLineSeperatorView.leadingAnchor, bottom: nil, trailing: bottomLineSeperatorView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
                
    }
    
    
    
    //MARK: - Target Selectors
    
    @objc fileprivate func handleValidateNextButton() {
        let isValid = usernameTextField.text?.count ?? 0 > 0 ? true : false
        if isValid == false {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = baseWhiteColor
            signUpButton.setTitleColor(.gray, for: .normal)
        } else {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = tikTokRed
            signUpButton.setTitleColor(.white, for: .normal)
        }
    }
    
    
    @objc fileprivate func handleSignUp() {
        signUpButton.isEnabled = false

        let username = usernameTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) {[weak self] (authResult, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 1.5)
                SVProgressHUD.setDefaultStyle(.dark)
                self?.signUpButton.isEnabled = true
            } else {
                //
                guard let self = self else {return}
                guard let uid = authResult?.user.uid else {return}
                let userMap : [String : Any] = ["username": username, "fullname": username, "email": self.emailAddress, "memberSince": Date().timeIntervalSince1970, "birthday": self.birthdate.timeIntervalSince1970]
                
                Database.database().reference().child("users").child(uid).setValue(userMap) { (error, _) in
                    if error != nil {
                        print("failed to save user info into database:", error?.localizedDescription ?? "")
                    } else {
                       
                        print("Successfully saved user")
                        let mainTabbarVC = MainTabBarController()
                        mainTabbarVC.modalPresentationStyle = .fullScreen
                        self.present(mainTabbarVC, animated: true) {
                            SVProgressHUD.showSuccess(withStatus: "Welcome To TikTok")
                            SVProgressHUD.setDefaultStyle(.dark)
                            SVProgressHUD.dismiss(withDelay: 3.0)
                        }
                    }
                }
            }
        }
    }
    
}
