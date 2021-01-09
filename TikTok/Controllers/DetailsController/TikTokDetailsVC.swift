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
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
   
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        commentInputAccessoryView.commentTextView.text = nil
        commentInputAccessoryView.commentTextView.placeholderLabel.text = "Add comment..."
    }
  

    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
}




  //MARK: - VerticalFeedCellDelegate
  extension TikTokDetailsVC: VerticalFeedCellDelegate {
    func didTapPlayButton(play: Bool) {
        //
    }
    
    
    func handleDidTapExitController() {
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
