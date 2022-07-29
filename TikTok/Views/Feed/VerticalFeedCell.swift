//
//  VerticalFeedCell.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 9/9/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
protocol VerticalFeedCellDelegate: AnyObject {
    func didTapPlayButton(play: Bool)
    func handleDidTapExitController(cell: VerticalFeedCell)
    func didTapCommentTextViewInCell(currentCell: VerticalFeedCell)
}

class VerticalFeedCell: UICollectionViewCell {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
        setUpPausePlayTapGesture()
        profileImageView.backgroundColor = .white
        handleRotateDiscJockey()
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDidTapExitController))
        swipeGesture.direction = .right
        addGestureRecognizer(swipeGesture)
        commentInputAccessoryView.commentTextView.text = nil
        commentInputAccessoryView.commentTextView.placeholderLabel.text = "Add comment..."
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentInputAccessoryView.commentTextView.text = nil
        commentInputAccessoryView.commentTextView.placeholderLabel.text = "Add comment..."
    }
   
    
    //MARK: - Properties
    weak var delegate: VerticalFeedCellDelegate?
    fileprivate let kRotationAnimationKey = "com.myapplication.rotationanimationkey" // Any key

    var post: Post? {
        didSet {
            guard let postUnwrapped = post, let url = URL(string: postUnwrapped.postImageUrl) else {return}
            postImageView.kf.setImage(with: url)
            postImageView.kf.indicatorType = .activity
            
            
            guard let profileImageUrl = URL(string: postUnwrapped.user.profileImageUrl) else {return}
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: profileImageUrl)
            
            loveCountLabel.text = postUnwrapped.likes.formatUsingAbbrevation()
            commentCountLabel.text = postUnwrapped.commentCount.formatUsingAbbrevation()
            shareCountLabel.text = postUnwrapped.views.formatUsingAbbrevation()
            
            
            let artistImageUrlString = "https://i.ytimg.com/vi/qHeqUnvWbhc/maxresdefault.jpg"//post?.postImageUrl ?? ""
            guard let artistImageUrl = URL(string: artistImageUrlString) else {return}
            artistImageView.kf.setImage(with: artistImageUrl)

            
            

        }
    }
    
     let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit//scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50 / 2
        return imageView
    }()
    
    
    fileprivate let addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "addIcon")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false 
        return button
    }()
    
    
    fileprivate let loveButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "heart")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    
    fileprivate let loveCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1.8M"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    fileprivate let commentButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "commentIcon")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    
    fileprivate let commentCountLabel: UILabel = {
       let label = UILabel()
       label.text = "10.2K"
       label.textColor = .white
       label.font = UIFont.boldSystemFont(ofSize: 12.5)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
   
    fileprivate let shareButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "shareIcon")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    
    fileprivate let shareCountLabel: UILabel = {
        let label = UILabel()
        label.text = "15.5K"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
     let discJockeyView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 50 / 2
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.addSubview(blurView)
        blurView.fillSuperview()
        return view
    }()
    
    
    fileprivate let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30 / 2
        imageView.backgroundColor = .yellow
//        let image = UIImage(named: "play")
//        imageView.image = image
        return imageView
    }()
    
    
    fileprivate let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13.5)
        label.text = "samma video, annan musik \n #tiktok #samisays11 #objective c"
        return label
    }()
    
    
    fileprivate let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.5)
        label.text = "@samisays11"
        label.textColor = .white
       return label
   }()
    
    
    fileprivate let musicIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let image = UIImage(named: "music")
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    
    fileprivate let musicTitleLabel: UILabel = {
        let label = UILabel()
         label.font = UIFont.systemFont(ofSize: 13.5)
         label.text = "Let Link - @WhoHeem"
         label.textColor = .white
//        label.backgroundColor = .red
        return label
    }()
    
    
    fileprivate let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "play")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.4)
        button.alpha = 0
        button.isUserInteractionEnabled = false
        return button
    }()

    
    let musicPlayingImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "music")
        imageView.image = image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    
    
    lazy var backTapGestureView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapExitController))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.isHidden = true
        return view
    }()
    
    
    
    fileprivate let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "backArrow")
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.white
        button.isUserInteractionEnabled = false
        return button
    }()

    
    fileprivate lazy var commentInputAccessoryView: CommentInputAccessoryView = {
        let view = CommentInputAccessoryView()
        view.isHidden = true
        view.backgroundColor = .clear
        view.commentTextView.textColor = .white
        view.commentTextView.backgroundColor = .clear
        view.emojisButton.tintColor = .lightGray
        view.mentionsButton.tintColor = .lightGray
        view.lineSeparatorView.alpha = 0
        return view
    }()
    
    
    lazy var commentTextViewTapGestureView: UIView = {
       let view = UIView()
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapCommentTextView))
       view.addGestureRecognizer(tapGesture)
       view.isUserInteractionEnabled = true
       return view
   }()
    
    
     let progressView: UIProgressView = {
      let progressView = UIProgressView()
      progressView.isHidden = true
      progressView.progressTintColor = UIColor.white
      progressView.trackTintColor = UIColor.lightGray
      progressView.constrainHeight(constant: 0.75)
//      progressView.transform = progressView.transform.scaledBy(x: 1, y: 0.5)
      return progressView
   }()
    
    
    //MARK: - Handlers
    
    fileprivate func setUpSubViews() {
        addSubview(postImageView)
        addSubview(discJockeyView)
        addSubview(commentInputAccessoryView)
        commentInputAccessoryView.addSubview(commentTextViewTapGestureView)
        addSubview(progressView)
        addSubview(shareButton)
        addSubview(shareCountLabel)
        addSubview(commentButton)
        addSubview(commentCountLabel)
        addSubview(loveButton)
        addSubview(loveCountLabel)
        addSubview(profileImageView)
        addSubview(addButton)
        discJockeyView.addSubview(artistImageView)
        addSubview(musicIcon)
        addSubview(musicTitleLabel)
        addSubview(captionLabel)
        addSubview(usernameLabel)
        insertSubview(pausePlayButton, aboveSubview: postImageView)
        insertSubview(backTapGestureView, aboveSubview: postImageView)
        backTapGestureView.addSubview(backButton)


        
        
        postImageView.fillSuperview()
        
        guard let maintabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
        let height = maintabbarController.tabBar.frame.height //?? 49.0

        discJockeyView.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: height + 15 , right: 8), size: .init(width: 50, height: 50))

        commentInputAccessoryView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: height))
        
        commentTextViewTapGestureView.fillSuperview()
       
        progressView.anchor(top: nil, leading: leadingAnchor, bottom: commentInputAccessoryView.topAnchor, trailing: trailingAnchor)
        
        
        shareButton.centerXAnchor.constraint(equalTo: discJockeyView.centerXAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: discJockeyView.topAnchor, constant: -45).isActive = true
        shareButton.constrainHeight(constant: 33)
        shareButton.constrainWidth(constant: 33)
         
          
          
       shareCountLabel.centerXAnchor.constraint(equalTo: shareButton.centerXAnchor).isActive = true
       shareCountLabel.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 5).isActive = true
    
      commentButton.centerXAnchor.constraint(equalTo: discJockeyView.centerXAnchor).isActive = true
      commentButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -45).isActive = true
      commentButton.constrainHeight(constant: 33)
      commentButton.constrainWidth(constant: 33)
            
      commentCountLabel.centerXAnchor.constraint(equalTo: commentButton.centerXAnchor).isActive = true
      commentCountLabel.topAnchor.constraint(equalTo: commentButton.bottomAnchor, constant: 5).isActive = true
              
        
        
        loveButton.centerXAnchor.constraint(equalTo: discJockeyView.centerXAnchor).isActive = true
        loveButton.bottomAnchor.constraint(equalTo: commentButton.topAnchor, constant: -45).isActive = true
        loveButton.constrainHeight(constant: 35)
        loveButton.constrainWidth(constant: 35)
        
        
        loveCountLabel.centerXAnchor.constraint(equalTo: loveButton.centerXAnchor).isActive = true
        loveCountLabel.topAnchor.constraint(equalTo: loveButton.bottomAnchor, constant: 5).isActive = true
    
             
        
        
        profileImageView.centerXAnchor.constraint(equalTo: discJockeyView.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loveButton.topAnchor, constant: -45).isActive = true
        profileImageView.constrainHeight(constant: 50)
        profileImageView.constrainWidth(constant: 50)
        
        
        addButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10.5).isActive = true
        addButton.constrainHeight(constant: 22)
        addButton.constrainWidth(constant: 22)
           
        
      artistImageView.centerInSuperview(size: .init(width: 30, height: 30))

            
        musicIcon.anchor(top: nil, leading: leadingAnchor, bottom: discJockeyView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 15, height: 15))
        
        musicTitleLabel.anchor(top: nil, leading: musicIcon.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: frame.width / 2, height: 0))
        
        musicTitleLabel.centerYAnchor.constraint(equalTo: musicIcon.centerYAnchor, constant: -1.3).isActive = true
        
        captionLabel.anchor(top: nil, leading: leadingAnchor, bottom: musicIcon.topAnchor, trailing: discJockeyView.leadingAnchor, padding: .init(top: 0, left: 5, bottom: 10, right: 8))
//
        usernameLabel.anchor(top: nil, leading: captionLabel.leadingAnchor, bottom: captionLabel.topAnchor, trailing: captionLabel.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        
        
        pausePlayButton.centerInSuperview(size: .init(width: 60, height: 60))
        
        backTapGestureView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 60, height: 44))
        
        backButton.centerInSuperview(size: .init(width: 30, height: 30))
        
    

    }
    
    
    
    func handleShowOptionalSubViewsInCell() {
        commentInputAccessoryView.isHidden = false
        progressView.isHidden = false
        backTapGestureView.isHidden = false
    }
    
    
    func handleResetCellUI() {
        rotateView(view: discJockeyView)
        pausePlayButton.alpha = 0
    }
    
        
    

    @objc func handleDidTapCommentTextView() {
        commentInputAccessoryView.alpha = 0
        delegate?.didTapCommentTextViewInCell(currentCell: self)
    }
    
   fileprivate func setUpPausePlayTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapPausePlayButton))
        addGestureRecognizer(tapGesture)
    }
    
    
    
    @objc fileprivate func handleDidTapPausePlayButton() {
        if pausePlayButton.alpha == 0 {
            pausePlayButton.alpha = 1
            delegate?.didTapPlayButton(play: false)
            stopRotatingView(view: discJockeyView)
        } else {
            pausePlayButton.alpha = 0
            delegate?.didTapPlayButton(play: true)
            rotateView(view: discJockeyView)
        }
    }
    
    
    
    func handleRotateDiscJockey() {
        rotateView(view: discJockeyView)
    }
    
    
    func rotateView(view: UIView, duration: Double = 3) {
        if view.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = CGFloat.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            view.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
       
    
    func stopRotatingView(view: UIView) {
        if view.layer.animation(forKey: kRotationAnimationKey) != nil {
            view.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
    }
    
    
    func handleAnimateMusicLabel() {
        
    }
    
    
    
    @objc func handleDidTapExitController() {
        delegate?.handleDidTapExitController(cell: self)
    }
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - TikTokDetailsVCDelegate
extension VerticalFeedCell: TikTokDetailsVCDelegate {
    
    func didTapZoomBack(scrollToIndexPath: IndexPath, isZoomingBackFromDetailsVC: Bool) {}
    
    func commentInputAccessoryViewDidResignFirstResponder(text: String) {
        if text.isEmpty == false {
        commentInputAccessoryView.commentTextView.placeholderLabel.text = nil
        }
        commentInputAccessoryView.commentTextView.text = text
        commentInputAccessoryView.alpha = 1
    }
}
