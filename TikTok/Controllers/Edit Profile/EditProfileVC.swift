//
//  EditProfileVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 6/1/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
protocol EditProfileVCDelegate: AnyObject {
    func didFinishPickingImage(image: UIImage)
}
class EditProfileVC: UICollectionViewController {
    
    //MARK: - Init
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavItems()
        setUpViews()
        handleObserveUserUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    
    //MARK: - Properties
    weak var delegate: EditProfileVCDelegate?
    private let cellReuseIdentifier = "EditProfileVCcellReuseIdentifier"
    private let headerId = "EditProfileVCheaderID"
    var selectedImage: UIImage?

    fileprivate var currentUser: User? = UserSession.shared.CURRENT_USER
    
    fileprivate let alertLabelYTranslation: CGFloat = 35
    fileprivate var isAlertlabelVisible = false
    fileprivate lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.darkGray
        label.textColor = .white
        label.font = defaultFont(size: 14.5)
        label.textAlignment = .center
        label.transform = CGAffineTransform(translationX: 0, y: -35)
        label.text = "Link copied"
        return label
    }()
    
    
    
    
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        view.backgroundColor = .white
        collectionView.register(EditProfileCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(EditProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        view.insertSubview(alertLabel, aboveSubview: collectionView)
        alertLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 35))
    }
    
    
    fileprivate func setUpNavItems() {
        navigationItem.title = "Edit Profile"
        navigationController?.setNavigationBarBorderColor(UIColor.lightGray.withAlphaComponent(0.5))
    }
    
    
    private func handleObserveUserUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveUserUpdate), name: .didUpdateUserData, object: nil)

    }
    
    private func handleSetUpData(user: User) -> [EditProfile] {
        let name = EditProfile(infoName: "Name", infoValue: user.fullname, placeHolderText: "fullname")
        let username = EditProfile(infoName: "Username", infoValue: user.username, placeHolderText: "@Username")
        let tiktok = EditProfile(infoName: "", infoValue: "tiktok.com/@\(user.username)", placeHolderText: "")
        let bio = EditProfile(infoName: "Bio", infoValue: user.bio ?? nil, placeHolderText: "Add a bio to your profile")
        let nonProfit = EditProfile(infoName: "Nonprofit", infoValue: "", placeHolderText: "Add nonprofit to your profile")
        let instagram = EditProfile(infoName: "Instagram", infoValue: "", placeHolderText: "Add instagram to your profile")
        let youtube = EditProfile(infoName: "Youtube", infoValue: "", placeHolderText: "Add Youtube to your profile")
        return [name, username, tiktok, bio, nonProfit, instagram, youtube]
    }
    
    
    private func handleOpenImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    
    private func handleUploadImage(image: UIImage) {
        if checkForConnection() == true {
            if let currentUid = CURRENT_UID {
                ImageUploader.uploadImage(image: image, type: .profile) { imageUrl in
                    Database.database().reference().child("users").child(currentUid).child("profileImageUrl").setValue(imageUrl)
                    SVProgressHUD.showSuccess(withStatus: "Success!")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            }
        }
        
    }
    
    
     func deleteCurrentProfileImgFromStorage(image: UIImage) {
        SVProgressHUD.show()
        guard let profileImgUrl = currentUser?.profileImageUrl else {return}
        //MARK: This is for when a new user is changing their PP for the first time. so we dont delete the default pp from storage.
        if profileImgUrl == DEFAULT_PROFILE_IMAGE_URL_STRING {
//            self.downloadProfileImageUrl(image: image)
            handleUploadImage(image: image)
            return
        }
        
        //else delete current PP and upload new one to storage
        Storage.storage().reference(forURL: profileImgUrl).delete {[weak self] (error) in
            if error != nil {
                print("error failed to delete current profileImg from Database Storage:", error?.localizedDescription ?? "")
                //still upload new pp even if you couldnt delete old one
                self?.handleUploadImage(image: image)
                return
            }
            
            self?.handleUploadImage(image: image)
            print("deleted previous proffile picture")
        }
        
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
                self.perform(#selector(self.handleAnimateAlertlabel), with: nil, afterDelay: 1.5)
            }
        }
    }
    
    
    //MARK: - Target Selectors
    @objc fileprivate func onDidReceiveUserUpdate() {
        currentUser = UserSession.shared.CURRENT_USER
        collectionView.reloadData()
    }
    
    
    
   
}


//MARK: - CollectionView Delegate & Datasource
extension EditProfileVC: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! EditProfileCell
        if let currentUser = currentUser {
            let data = handleSetUpData(user: currentUser)
            cell.editProfile = data[indexPath.item]
        }
        
        if indexPath.item == 2 {
            cell.lineSeperatorView.isHidden = true
            cell.rightArrowButton.setImage(copyIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else if indexPath.item == 4 {
            cell.lineSeperatorView.isHidden = false
            cell.rightArrowButton.setImage(rightArrowIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            cell.lineSeperatorView.isHidden = true
            cell.rightArrowButton.setImage(rightArrowIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.item == 4 ? .init(width: view.frame.width, height: 65) : .init(width: view.frame.width, height: 45)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let currentUser = currentUser {
            let data = handleSetUpData(user: currentUser)
            return data.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! EditProfileHeader
        header.user = currentUser
        header.didTapChangeProfilePhoto = { [weak self] in
            self?.handleOpenImagePicker()
        }
        
        delegate = header
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 195)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            if let currentUser = currentUser {
                let editUserInfoVC = EditUserInfoVC(userInfoToEdit: .editName("Name"), user: currentUser)
                navigationController?.pushViewController(editUserInfoVC, animated: true)
            }
        case 1:
            if let currentUser = currentUser  {
                let editUserInfoVC = EditUserInfoVC(userInfoToEdit: .editUsername("Username"), user: currentUser)
                navigationController?.pushViewController(editUserInfoVC, animated: true)
            }
        case 2:
            let pasteboard = UIPasteboard.general
            pasteboard.string = "tiktok.com/\(currentUser?.username ?? "")"
            handleAnimateAlertlabel()
        case 3:
            if let currentUser = currentUser   {
                let editUserInfoVC = EditUserInfoVC(userInfoToEdit: .editBio("Bio"), user: currentUser)
                navigationController?.pushViewController(editUserInfoVC, animated: true)
            }
        case 4:
            print("case 4")
        case 5:
            print("case 5")
        case 6:
            print("case 6")
        default:
            print("default")
        }
    }
}


//MARK: UIImagePickerDelegate
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        guard let newProfilePhoto = selectedImage else {return}
        deleteCurrentProfileImgFromStorage(image: newProfilePhoto)
        picker.dismiss(animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
