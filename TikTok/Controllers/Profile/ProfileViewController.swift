//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/14/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
fileprivate let cellReuseIdentifier = "cellReuseIdentifier"
fileprivate let headerReuseIdentifier = "headerReuseIdentifier"
fileprivate let footerReuseIdentifier = "footerReuseIdentifier"
class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    //MARK: - Init

    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = UserSession.shared.CURRENT_USER
        setUpCollectionView()
        setUpTabbarVisibility()
        setUpNavItems()
        handleFetchPost()
        handleObserveUserUpdates()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarBorderColor(.clear) //removes navline
        if tabBarWasVisibleOnViewDidLoad == true {
            handleUnHideTabbar()
            navigationController?.navigationBar.isHidden = false
//            navigationItem.prompt = ""; // this adds empty space on top
        }
    }
    
    
   
    
    
    //MARK: - Properties
    fileprivate weak var  transitionCell: ProfileCell?
    fileprivate let zoomNavigationDelegate = ZoomTransitionDelegate()
    var scrollToIndexPath = IndexPath(item: 0, section: 0) //where we will zoom to
    var isZoomingBackFromDetailsVC = false
          
    
   fileprivate var tabBarWasVisibleOnViewDidLoad = true
    
//    override var prefersStatusBarHidden: Bool {
//      return false
//    }
//
    
    
     var currentUser: User? {
        didSet {
            navigationItem.title = currentUser?.fullname
        }
    }
    
    

    fileprivate var posts: [Post] = [Post]()
    
    
    
    //MARK: - Handlers
    fileprivate func setUpCollectionView() {
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
    }
    
    
    fileprivate func setUpNavItems() {
        navigationController?.setNavigationBarBorderColor(.clear) //removes navline
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "•••", style: .plain, target: self, action: #selector(handleCustomPresentations))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: threedotmenu_ic, style: .plain, target: self, action: #selector(handleCustomPresentations))

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: addfriends_ic, style: .plain, target: self, action: nil)
        
        
        
////        //add shadow radius below navbar
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
//        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    
    fileprivate func handleUnHideTabbar() {
       if tabBarController?.tabBar.isHidden == true {
           UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
               self?.tabBarController?.tabBar.isHidden = false

           })
       }
     }
    
    
    fileprivate func setUpTabbarVisibility() {
        if tabBarController?.tabBar.isHidden == true {
            tabBarWasVisibleOnViewDidLoad = false
        } else {
            tabBarWasVisibleOnViewDidLoad = true
        }
    }
    
    
    
    
    
  
    
    private func handleFetchPost() {
        Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else {return}
            dict.forEach { (key, value) in
                let user = self.currentUser!
                guard let postDict = value as? [String : Any] else {return}
                let post = Post(user: user, dictionary: postDict)
                self.posts.append(post)
                self.collectionView.reloadData()
            }
        }) { (error) in
            print("failed to fetch posts:", error.localizedDescription)
        }
    }
    
    private func handleObserveUserUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveUserUpdate), name: .didUpdateUserData, object: nil)

    }
    
    
    
    
    //MARK: - Target Selectors
    @objc fileprivate func onDidReceiveUserUpdate() {
        self.currentUser = UserSession.shared.CURRENT_USER
        collectionView.reloadData()
//        print("DEBUG: onDidReceiveUserUpdate")
    }

    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
}



//MARK: - CollectionView Protocols
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ProfileCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3 - 1
        return .init(width: width, height: width * 1.5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ProfileHeader
        header.user = currentUser
        header.delegate = self
        return header
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 340)
    }
    
    
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let layout = UICollectionViewFlowLayout()
//        let tiktokDetailsVC = TikTokDetailsVC(collectionViewLayout: layout)
//        self.tabBarController?.tabBar.isHidden = true
//        navigationController?.pushViewController(tiktokDetailsVC, animated: true)
//    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileCell else {return}
            transitionCell = cell
            navigationController?.delegate = zoomNavigationDelegate
            let tiktokDetailsVC = TikTokDetailsVC(collectionViewLayout: UICollectionViewFlowLayout())
            tiktokDetailsVC.currentIndexPath = indexPath
            tiktokDetailsVC.postData = posts
            tiktokDetailsVC.delegate = self
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [unowned self] in
                self.tabBarController?.tabBar.isHidden = true

            }) {[weak self](completed) in
                self?.navigationController?.pushViewController(tiktokDetailsVC, animated: true)
            }
        }
    
    
    
    @objc func handleCustomPresentations() {
//        let slideVC = OverlayController()
//       slideVC.modalPresentationStyle = .custom
//       slideVC.transitioningDelegate = self
//       self.present(slideVC, animated: true, completion: nil)
//        let enterTextVC = EnterTextVC()
//       self.present(enterTextVC, animated: true, completion: nil)
    }
    
    
   
    
}


extension ProfileViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}



//MARK: - TikTokDetailsVCDelegate
extension ProfileViewController: TikTokDetailsVCDelegate {
    func commentInputAccessoryViewDidResignFirstResponder(text: String) {}
    
   ///indicates we are backing out from details vc and scrolls to the right cell using indexpath
    func didTapZoomBack(scrollToIndexPath: IndexPath, isZoomingBackFromDetailsVC: Bool) {
        self.scrollToIndexPath = scrollToIndexPath
        self.isZoomingBackFromDetailsVC = isZoomingBackFromDetailsVC
    }
    
    
}


//MARK: - ZoomViewControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: ZoomViewController, UINavigationControllerDelegate {
    
    func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
        if isZoomingBackFromDetailsVC == true {
            isZoomingBackFromDetailsVC = !isZoomingBackFromDetailsVC
            return getImageViewFromCollectionViewCell(for: scrollToIndexPath)
        } else {
            
            return  transitionCell?.imageView ?? UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
        }
        
    }
    
    func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView? {
        return nil
    }
    
    
    
    //This function prevents the collectionView from accessing a deallocated cell. In the event
    //that the cell for the selectedIndexPath is nil, a default UIImageView is returned in its place
    func getImageViewFromCollectionViewCell(for selectedIndexPath: IndexPath) -> UIImageView {
        if posts.isEmpty == false { // if we dont do this, the app might crash
            //Get the array of visible cells in the collectionView
            let visibleCells = self.collectionView.indexPathsForVisibleItems
            
            //If the current indexPath is not visible in the collectionView,
            //scroll the collectionView to the cell to prevent it from returning a nil value
            if !visibleCells.contains(self.scrollToIndexPath) {
                
                //Scroll the collectionView to the current selectedIndexPath which is offscreen
                self.collectionView.scrollToItem(at: self.scrollToIndexPath, at: .centeredVertically, animated: false)
                
                //Reload the items at the newly visible indexPaths
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                self.collectionView.layoutIfNeeded()
                
                //Guard against nil values
                guard let guardedCell = (self.collectionView.cellForItem(at: self.scrollToIndexPath) as? ProfileCell) else {
                    //Return a default UIImageView
                    return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
                }
                //The PhotoCollectionViewCell was found in the collectionView, return the image
                return guardedCell.imageView
            }
            else {
                
                //Guard against nil return values
                guard let guardedCell = self.collectionView.cellForItem(at: self.scrollToIndexPath) as? ProfileCell else {
                    //Return a default UIImageView
                    return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
                }
                //The PhotoCollectionViewCell was found in the collectionView, return the image
                return guardedCell.imageView
            }
            
        } else {
            //if post was deleted from another view and now indexes are empty return an empty image
            return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            
        }
        
        
    }
    
    
    
    
}


//MARK: - ProfileHeaderDelegate
extension ProfileViewController: ProfileHeaderDelegate {
    func didTapEditProfile() {
        let layout = UICollectionViewFlowLayout()
        let editProfileVC = EditProfileVC(collectionViewLayout: layout)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    func didTapBookmark() {
        let bookmarkVC = BookmarkVC()
        navigationController?.pushViewController(bookmarkVC, animated: true)
    }
}


extension UINavigationController {
    
    func setNavigationBarBorderColor(_ color:UIColor) {
        self.navigationBar.shadowImage = color.as1ptImage()
    }
}

extension UIColor {
    
    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
