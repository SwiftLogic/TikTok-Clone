//
//  SharePostVC.swift
//  SamiSays11
//
//  Created by Osaretin Uyigue on 5/05/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class SharePostVC: UIViewController {
    
    //MARK: Init
    init(videoUrl: URL) {
        self.originalVideoURL = videoUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        handleSetUpNavItems()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       handleRefreshNavigationBar()
        saveVideoTobeUploadedToServerToTempDirectory(sourceURL: originalVideoURL) {[weak self] (outputURL) in
            self?.encodedVideoURL = outputURL
            print("encodedVideoURL:", outputURL)
        }
    
       
    }
    
    
    //MARK: - Properties
    
    fileprivate let originalVideoURL: URL
    fileprivate var encodedVideoURL: URL?
    
    
    
   
    
    
    fileprivate let draftsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Drafts", for: .normal)
        button.setImage(archiveIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        button.titleLabel?.font = defaultFont(size: 15.5)
        button.imageEdgeInsets = .init(top: 0, left: -12, bottom: 0, right: 0)
        button.titleEdgeInsets = .init(top: 3.5, left: 0, bottom: 0, right: -5)
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    }()
    
    fileprivate let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setImage(postUploadIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = tikTokRed
        button.titleLabel?.font = defaultFont(size: 15.5)
        button.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 0)
        button.titleEdgeInsets = .init(top: 2, left: 0, bottom: 0, right: -5)
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleDidTapUploadButton), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate let shareToLabel: UILabel = {
        let label = UILabel()
        label.text = "Automatically share to:"
        label.font = avenirRomanFont(size: 12.5)
        label.textColor = .gray
        return label
    }()
    
    
    
    fileprivate let buttonsDimensions: CGFloat = 45
    
    fileprivate lazy var iMessagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(iMessageIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.layer.cornerRadius = buttonsDimensions / 2
        button.constrainHeight(constant: buttonsDimensions)
        button.constrainWidth(constant: buttonsDimensions)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        return button
    }()
    
    
    
    fileprivate lazy var snapchatButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(snapchatIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
       button.clipsToBounds = true
       button.tintColor = .lightGray
       button.layer.cornerRadius = buttonsDimensions / 2
       button.constrainHeight(constant: buttonsDimensions)
       button.constrainWidth(constant: buttonsDimensions)
       button.layer.borderWidth = 0.5
       button.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
       return button
   }()
    
    
    fileprivate lazy var instagramButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(instagramIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.layer.cornerRadius = buttonsDimensions / 2
        button.constrainHeight(constant: buttonsDimensions)
        button.constrainWidth(constant: buttonsDimensions)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        return button
    }()
    
    
    fileprivate lazy var instagramStoriesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(igStoriesIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.layer.cornerRadius = buttonsDimensions / 2
        button.constrainHeight(constant: buttonsDimensions)
        button.constrainWidth(constant: buttonsDimensions)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
           return button
       }()
       
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
        return imageView
    }()
    
    
    fileprivate let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14.5)
        return textView
    }()
    
    
    fileprivate let hashtagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("#Hashtag", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderWidth = 1.2
        button.layer.borderColor = baseWhiteColor.cgColor//UIColor(white: 0.5, alpha: 0.5).cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    }()
    
    fileprivate let mentionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("@Friends", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderWidth = 1.2
        button.layer.borderColor = baseWhiteColor.cgColor//UIColor(white: 0.5, alpha: 0.5).cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    }()
    
    
    fileprivate let selectVideoCoverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Select Cover", for: .normal)
        button.titleLabel?.font = defaultFont(size: 11.5)//UIFont.boldSystemFont(ofSize: 12.5)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return button
    }()
    
    
    fileprivate let lineSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = baseWhiteColor
        return view
    }()
    
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5//10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let redView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 170).isActive = true
        view.backgroundColor = .white
        return view
    }()

    let blueView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        return view
    }()

    let greenView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        view.backgroundColor = .green
        return view
    }()
    
    
    fileprivate let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Public"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var privacyButton = self.handleCreateButtons(buttonIcon: privacyIcon, buttonTitle: "   Who can view this video")
    
    lazy var allowCommentsButton = self.handleCreateButtons(buttonIcon: allowCommentIcon, buttonTitle: "   Allow comments")
    
    lazy var allowDuetsButton = self.handleCreateButtons(buttonIcon: allowDuetIcon, buttonTitle: "   Allow Duet")

    lazy var allowSticthButton = self.handleCreateButtons(buttonIcon: allowStitchIcon, buttonTitle: "   Allow Stitch")

    lazy var saveToDeviceButton = self.handleCreateButtons(buttonIcon: saveVideoToDeviceIcon, buttonTitle: "   Save to Device")
    
    
    lazy var rightArrowButton = self.handleCreateButtons(buttonIcon: rightArrowIcon, buttonTitle: "Public")

    
    
    
    fileprivate let allowCommentsSwitch: UISwitch = {
        let uiswitch = UISwitch()
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        uiswitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        uiswitch.isOn = true
        return uiswitch
    }()
    
    
    fileprivate let allowDuetsSwitch: UISwitch = {
        let uiswitch = UISwitch()
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        uiswitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        uiswitch.isOn = true
        return uiswitch
    }()
    
    
    fileprivate let allowStitchSwitch: UISwitch = {
        let uiswitch = UISwitch()
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        uiswitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        uiswitch.isOn = true
        return uiswitch
    }()
    
    
    fileprivate let saveToDeviceSwitch: UISwitch = {
        let uiswitch = UISwitch()
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        uiswitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        uiswitch.isOn = true
        return uiswitch
    }()

    //MARK: - Handlers
    
    
    fileprivate func handleSetUpNavItems() {
        navigationItem.title = "Post"
        
    }
    
    fileprivate func handleRefreshNavigationBar() {
        // Force the navigation bar to update its size. hide and unhiding it fforces a redraw and fixes a bug
        guard let navController = navigationController else {return}
        navController.setNeedsStatusBarAppearanceUpdate()
        navController.isNavigationBarHidden = true
        navController.isNavigationBarHidden = false
    }
    
    
    fileprivate func setUpViews() {
        view.addSubview(draftsButton)
        view.addSubview(postButton)
        
        let buttonWidth : CGFloat = view.frame.width / 2 - 15
        let buttonHeight : CGFloat = 45

        draftsButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 20, right: 0), size: .init(width: buttonWidth, height: buttonHeight))
        
        
        postButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 12), size: .init(width: buttonWidth, height: buttonHeight))
        
        
        
        
        let stackView = UIStackView(arrangedSubviews: [iMessagesButton, instagramButton, instagramStoriesButton, snapchatButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: draftsButton.leadingAnchor, bottom: draftsButton.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 25, right: 0), size: .init(width: 216, height: 45))
        
       
        view.addSubview(shareToLabel)
        shareToLabel.anchor(top: nil, leading: draftsButton.leadingAnchor, bottom: stackView.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0))

        

        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(redView)
        scrollViewContainer.addArrangedSubview(blueView)
        scrollViewContainer.addArrangedSubview(greenView)

        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: shareToLabel.topAnchor).isActive = true

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        
        
        redView.addSubview(thumbnailImageView)
        thumbnailImageView.anchor(top: redView.topAnchor, leading: nil, bottom: nil, trailing: redView.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 15), size: .init(width: 90, height: 125))


        redView.addSubview(textView)
        textView.anchor(top: thumbnailImageView.topAnchor, leading: redView.leadingAnchor, bottom: thumbnailImageView.bottomAnchor, trailing: thumbnailImageView.leadingAnchor, padding: .init(top: 0, left: 6, bottom: 0, right: 5))


        redView.addSubview(hashtagButton)
        hashtagButton.anchor(top: nil, leading: textView.leadingAnchor, bottom: thumbnailImageView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 80, height: 25))


        redView.addSubview(mentionsButton)
        mentionsButton.anchor(top: nil, leading: hashtagButton.trailingAnchor, bottom: thumbnailImageView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: .init(width: 80, height: 25))
        
        
        thumbnailImageView.addSubview(selectVideoCoverButton)
        selectVideoCoverButton.anchor(top: nil, leading: thumbnailImageView.leadingAnchor, bottom: thumbnailImageView.bottomAnchor, trailing: thumbnailImageView.trailingAnchor, size: .init(width: 0, height: 25))


        redView.addSubview(lineSeperatorView)
        lineSeperatorView.anchor(top: hashtagButton.bottomAnchor, leading: redView.leadingAnchor, bottom: nil, trailing: redView.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
        

        let vstackView = UIStackView(arrangedSubviews: [privacyButton, allowCommentsButton, allowDuetsButton, allowSticthButton, saveToDeviceButton])
        
        saveToDeviceButton.imageEdgeInsets = .init(top: -2, left: 0, bottom: 0, right: 0)

        vstackView.axis = .vertical
        vstackView.alignment = .leading
        vstackView.spacing = 15//20
        vstackView.distribution = .fillEqually
        
        blueView.addSubview(vstackView)
        vstackView.anchor(top: blueView.topAnchor, leading: blueView.leadingAnchor, bottom: blueView.bottomAnchor, trailing: blueView.trailingAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 0))
        
        
        rightArrowButton.semanticContentAttribute = .forceRightToLeft// This Aligns button image to right edge of UIButton
        rightArrowButton.titleEdgeInsets = .init(top: 0, left: -12, bottom: 0, right: 0)

        blueView.addSubview(rightArrowButton)
        rightArrowButton.centerYAnchor.constraint(equalTo: privacyButton.centerYAnchor).isActive = true
        rightArrowButton.constrainToRight(paddingRight: -10)

        
        
        blueView.addSubview(allowCommentsSwitch)
        allowCommentsSwitch.centerYAnchor.constraint(equalTo: allowCommentsButton.centerYAnchor).isActive = true
        allowCommentsSwitch.constrainToRight(paddingRight: -10)
        
        
        blueView.addSubview(allowDuetsSwitch)
        allowDuetsSwitch.centerYAnchor.constraint(equalTo: allowDuetsButton.centerYAnchor).isActive = true
        allowDuetsSwitch.constrainToRight(paddingRight: -10)

        
        blueView.addSubview(allowStitchSwitch)
        allowStitchSwitch.centerYAnchor.constraint(equalTo: allowSticthButton.centerYAnchor).isActive = true
        allowStitchSwitch.constrainToRight(paddingRight: -10)

        
       blueView.addSubview(saveToDeviceSwitch)
       saveToDeviceSwitch.centerYAnchor.constraint(equalTo: saveToDeviceButton.centerYAnchor).isActive = true
       saveToDeviceSwitch.constrainToRight(paddingRight: -10)


    }
    
    
    
    fileprivate func handleCreateButtons(buttonIcon: UIImage?, buttonTitle: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.setImage(buttonIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.setTitleColor(UIColor.black.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = avenirRomanFont(size: 14)
        return button
    }
    
   
    //MARK: - Target Selectors
    @objc func handleDidTapUploadButton() {
        //first check if there is network before proceeding with upload to storage
        if Reachability.isConnectedToNetwork() {
//            print("Yes there is network")
            uploadVideoUrlToStorage()
        } else {
//            print("No network!!")
            presentNetworkErrorMessage()
        }
    }
    
    
    
    @objc func uploadVideoUrlToStorage() {
            postButton.isEnabled = false
            guard let encondedVideoUrlUnwrapped  = encodedVideoURL else {return}
            
            let filename = NSUUID().uuidString + ".mov"
            let storageItem = Storage.storage().reference().child("post_videos")
            
            let uploadTask = storageItem.child(filename).putFile(from: encondedVideoUrlUnwrapped, metadata: nil) { (metadata, error) in
                if let err = error {
                    print("Failed to upload videoUrl to Database:", err.localizedDescription)
                    handleNetworkCheck()
                    SVProgressHUD.showError(withStatus: "Error uploading videoUrl to storage")
                    SVProgressHUD.dismiss(withDelay: 2.5)
                    return
                }
                
                //grab download urlToStored item so we can save it in DB
                storageItem.child(filename).downloadURL(completion: { (videoUrl, error) in
                    if error != nil {
                        print("Failed to download url:", error?.localizedDescription ?? "")
                        SVProgressHUD.showError(withStatus: "Error downloading videourl's downloadURL")
                        SVProgressHUD.dismiss(withDelay: 2.5)
                        return
                    }
                    
                    guard let videoUrlString = videoUrl?.absoluteString else {return}
                    self.uploadThumbnailImageToStorage { (postImageUrl) in
                        self.handleSavePostInfoToDB(postImageUrl: postImageUrl, videoUrlString: videoUrlString)
                    }
                })
            }
        }
    
    
    
    func uploadThumbnailImageToStorage(completion: @escaping (String) -> ()) {
            let filename = NSUUID().uuidString
            guard let selectedPhoto = thumbnailImageView.image else {return}
            guard let uploadData = selectedPhoto.jpegData(compressionQuality: 1) else {return}
            let storageItem = Storage.storage().reference().child("post_images")
           let uploadTask = storageItem.child(filename).putData(uploadData, metadata: nil) { (metadata, error) in
                if let err = error {
                    print("Failed to upload Image Data to storage:", err.localizedDescription)
                    handleNetworkCheck()
                    SVProgressHUD.showError(withStatus: "Error uploading thumbnailImage to storage")
                    SVProgressHUD.dismiss(withDelay: 2.5)
                    return
                }
            
            storageItem.child(filename).downloadURL(completion: { (imageUrl, error) in
                if error != nil {
                    print("Failed to download url:", error?.localizedDescription ?? "")
                    SVProgressHUD.showError(withStatus: "Error downloading thumbnailImage")
                    SVProgressHUD.dismiss(withDelay: 2.5)
                    return
                }
                
                //grab download urlToStored item so we can save it in DB
                guard let postImageUrl = imageUrl?.absoluteString else {return}
                completion(postImageUrl)
            })
            
            }
                        
        }
        
       

       
        
        
    
    
    fileprivate func handleSavePostInfoToDB(postImageUrl: String, videoUrlString: String) {
                
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
               let ref = Database.database().reference().child("posts")
               guard let postId = ref.childByAutoId().key else {return}
        let postHashMap: [String: Any] = ["postImageUrl": postImageUrl, "videoUrl": videoUrlString, "caption": textView.text ?? "",  "creationDate": Date().timeIntervalSince1970, "ownerUid": currentUid, "likes": 0, "views": 0, "commentCount": 0]
//               let postHashMap : [String : Any] = ["postImageUrl": "", "ownerUid": currentUid, "views": 0, "likes": 0, "caption": textView.text ?? ""]
               ref.child(postId).setValue(postHashMap)
               SVProgressHUD.showSuccess(withStatus: "Successfuly saved to db")
               SVProgressHUD.dismiss(withDelay: 2.0)
        dismiss(animated: true) {
            FileManager.default.clearTmpDirectory()

        }
    }
        
    
}


extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}
