//
//  TikTokDetailsVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/21/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
fileprivate let cellReuseIdentifier = "cellReuseIdentifier"
fileprivate let headerReuseIdentifier = "headerReuseIdentifier"
fileprivate let footerReuseIdentifier = "footerReuseIdentifier"
protocol TikTokDetailsVCDelegate: class {
    func commentInputAccessoryViewDidResignFirstResponder(text: String)
    func didTapZoomBack(scrollToIndexPath: IndexPath, isZoomingBackFromDetailsVC: Bool)

}
class TikTokDetailsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        view.backgroundColor = UIColor.black
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
    //MARK: - LifeCycle
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            isOpeningForFirstTime = false
            collectionView.alpha = 1
            //so when we can use zoomview animation to exit this controller
            navigationController?.delegate = zoomNavigationDelegate
                    
            
        }
        
        
       
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            handleRefreshNavigationBar()
            collectionView.backgroundColor = .clear //.black if you remove lotte view change the color back to black
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            hideStatusBar = false
            navigationController?.isNavigationBarHidden = false//isAboutToPresentAnotherController == false ? false : true
            collectionView.backgroundColor = .clear // so we can see the controller we are zooming into it. DONT REMOVE
        }
    
    
    fileprivate func handleRefreshNavigationBar() {
           // Force the navigation bar to update its size. hide and unhiding it fforces a redraw and fixes a bug
           guard let navController = navigationController else {return}
           navController.setNeedsStatusBarAppearanceUpdate()
           navController.isNavigationBarHidden = false
           navController.isNavigationBarHidden = true
       }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = false
//        navigationItem.prompt = " "; // this adds empty space on top
//
//
//    }
//    
    
    //MARK: - Properties
    weak var delegate : TikTokDetailsVCDelegate?
    var postData: [Post] = [Post]()
    
    fileprivate let zoomNavigationDelegate = ZoomTransitionDelegate()
    var currentIndexPath = IndexPath()
    var isOpeningForFirstTime = true
    
    
    private var hideStatusBar: Bool = true {
        didSet {
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.setNeedsStatusBarAppearanceUpdate()
            }
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    
//    override var prefersStatusBarHidden: Bool {
//      return true
//    }
    
    
    override var inputAccessoryView: UIView? {
         get {
             return commentInputAccessoryView
         }
       }


     override var canBecomeFirstResponder: Bool {
         return true
     }
    
    
    lazy var zoomingImageView: UIImageView = {
         let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
       
    
    fileprivate lazy var commentInputAccessoryView: CommentInputAccessoryView = {
       let height = tabBarController?.tabBar.frame.height ?? 49.0
       let view = CommentInputAccessoryView(frame: CGRect(x: 0, y: 0, width: 0, height: height))
       view.alpha = 0
       view.commentTextView.delegate = self
       return view
   }()
    

    
    lazy var swipeGesture: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissKeyBoard))
        swipeGesture.direction = .down
        return swipeGesture
    }()
    
    
    
    //MARK: - Handlers
    fileprivate func setUpCollectionView() {
        collectionView.register(VerticalFeedCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.alpha = 0
        view.insertSubview(zoomingImageView, belowSubview: collectionView)
        zoomingImageView.frame = view.bounds
        

    }
    
    @objc func centerCollectionView() {
         collectionView.scrollToItem(at: currentIndexPath, at: .centeredVertically, animated: true)
       }
    
    
    @objc func handleDismissKeyBoard() {
        collectionView.removeGestureRecognizer(swipeGesture)
        commentInputAccessoryView.commentTextView.resignFirstResponder()
//        print("gesture count:", collectionView.gestureRecognizers?.count)
    }
    
    
    //MARK: - CollectionView Protocols
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! VerticalFeedCell
        cell.delegate = self
        cell.handleShowOptionalSubViewsInCell()
        cell.post = postData[indexPath.item]
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        isOpeningForFirstTime == true ? collectionView.scrollToItem(at: currentIndexPath, at: .centeredVertically, animated: false) : nil
       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
   
    
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let index = targetContentOffset.pointee.y / view.frame.height
//        let indexPath = IndexPath(item: Int(index), section: 0)
//        currentIndexPath = indexPath
////               print("scrollViewWillEndDragging: ", indexPath)
//
//    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        commentInputAccessoryView.commentTextView.text = nil
        commentInputAccessoryView.commentTextView.placeholderLabel.text = "Add comment..."
//        if decelerate == false {
//            centerCollectionView()
//            triggerHapticFeedback()
//
//        }
    }
  

//       override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//           centerCollectionView()
//           triggerHapticFeedback()
//
//       }
//    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
}




  //MARK: - VerticalFeedCellDelegate
  extension TikTokDetailsVC: VerticalFeedCellDelegate {
    func didTapPlayButton(play: Bool) {
        //
    }
    
    
    func handleDidTapExitController(cell: VerticalFeedCell) {
        cell.isHidden = true
        cell.prepareForReuse()
//        removePeriodicTimeObserver()
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        delegate?.didTapZoomBack(scrollToIndexPath: indexPath, isZoomingBackFromDetailsVC: true)
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    func didTapCommentTextViewInCell(currentCell: VerticalFeedCell) {
        commentInputAccessoryView.alpha = 1
        commentInputAccessoryView.commentTextView.becomeFirstResponder()
        delegate = currentCell
        collectionView.isScrollEnabled = false
        collectionView.addGestureRecognizer(swipeGesture)
//        print("gesture count:", collectionView.gestureRecognizers?.count)

       
    }
    
   
    
    
}



//MARK: - UITextViewDelegate
extension TikTokDetailsVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        commentInputAccessoryView.alpha = 0
        delegate?.commentInputAccessoryViewDidResignFirstResponder(text:textView.text)
        collectionView.isScrollEnabled = true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" { //Check if last char is newline
            textView.text.removeLast() //Remove newline
            textView.resignFirstResponder() //Dismiss keyboard
        }
    }
    
    
    

}

//MARK: - ZoomViewController
extension TikTokDetailsVC: ZoomViewController, UINavigationControllerDelegate {
    
    //MARK: - ZoomViewController Delegates
       func zoomingBackgroundView(for transition: ZoomTransitionDelegate) -> UIView? {
           return nil
       }
       
       
       
       func zoomingImageView(for transition: ZoomTransitionDelegate) -> UIImageView? {
           return zoomingImageView
       }
       
    
}
