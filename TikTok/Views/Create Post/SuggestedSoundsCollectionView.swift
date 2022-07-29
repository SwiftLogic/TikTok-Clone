//
//  SuggestedSoundsCollectionView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 5/2/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

//
//  CollectionViewCell
//
//  Created by Osaretin Uyigue on 4/29/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import UIKit
import AVFoundation
fileprivate let headerReuseIdentifier = "SuggestedSoundsCollectionViewheaderReuseIdentifier"
fileprivate let cellReuseIdentifier = "SuggestedSoundsCollectionViewCellId"

class SuggestedSoundsCollectionView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    deinit {
        print("SuggestedSoundsCollectionView was deinited")
    }
    
    
    //MARK: - Properties
    var didTapSearchMoreSounds: (() -> Void)?
    fileprivate lazy var selectedMusic = musicData().first! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false 
        return collectionView
    }()
    
    fileprivate var avAudioPlayer: AVAudioPlayer?

        
    //MARK: - Handlers
    
    fileprivate func setUpViews() {
        addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.register(SuggestedSoundsCell.self, forCellWithReuseIdentifier: headerReuseIdentifier)
        collectionView.register(SuggestedSoundsCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    
    fileprivate func  musicData() -> [Music] {
        let anyBody_Burnaboy = Music(coverPhotoUrl: "anybody_burnaboy", title: "Anybody", filePath: "Burna Boy - Anybody.mp3")
        let ye_Burnaboy = Music(coverPhotoUrl: "burna_boy_anybody_cover", title: "Gbona", filePath: "Burna Boy-Gbona.mp3")
        let joeBoy_Call = Music(coverPhotoUrl: "Joeboy_Call_coverboy", title: "Call", filePath: "JoeBoy-Call.mp3")
        let wizkid_love_Mybaby = Music(coverPhotoUrl: "wizkid_superstar", title: "Love My Baby", filePath: "Love My Baby.mp3")
        
        
        let kilofeshe = Music(coverPhotoUrl: "kilofeshe_cover", title: "Kilofeshe", filePath: "JoeBoy-Call.mp3")
        let rema_bounce = Music(coverPhotoUrl: "rema_bounce", title: "Bounce", filePath: "JoeBoy-Call.mp3")
        let joeboy_focus = Music(coverPhotoUrl: "joeboy_focus", title: "Focus", filePath: "JoeBoy-Call.mp3")
        let gyakie_Forever_Remix = Music(coverPhotoUrl: "Gyakie_Forever_Remix", title: "Gyakie Forever Remix", filePath: "JoeBoy-Call.mp3")
        let tiwa_savage_koroba = Music(coverPhotoUrl: "tiwa_savage_koroba", title: "Koroba", filePath: "JoeBoy-Call.mp3")
        let crayon_toocoreect = Music(coverPhotoUrl: "crayon_toocoreect", title: "Too Correct", filePath: "JoeBoy-Call.mp3")
        return [anyBody_Burnaboy, ye_Burnaboy, joeBoy_Call, wizkid_love_Mybaby, kilofeshe, rema_bounce, joeboy_focus, gyakie_Forever_Remix, tiwa_savage_koroba, crayon_toocoreect]
    }
    
    
    fileprivate func handleCellSelection(cell: SuggestedSoundsCell, music: Music) {
        if music == selectedMusic {
            cell.imageView.layer.borderWidth = 2.5
            cell.imageView.layer.borderColor = tikTokRed.cgColor
            cell.titleLabel.textColor = tikTokRed
        } else {
            cell.imageView.layer.borderWidth = 0
            cell.imageView.layer.borderColor = UIColor.clear.cgColor
            cell.titleLabel.textColor = .white
        }
    }
    
    
    fileprivate func handlePlayMusic(withFilePath filePath: String) {
        let path = Bundle.main.path(forResource: filePath, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: url)
            avAudioPlayer?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - CollectionView Delegate & Datasource
extension SuggestedSoundsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! SuggestedSoundsCell
            cell.handleSetUpHeaderCellData() 
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SuggestedSoundsCell
            let musics_Data = musicData()
            let music = musics_Data[indexPath.item]
            cell.music = music
            handleCellSelection(cell: cell, music: music)
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / 4 
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : musicData().count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            didTapSearchMoreSounds?()
        } else {
            let music = musicData()[indexPath.item]
            selectedMusic = music
            handlePlayMusic(withFilePath: music.filePath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return -8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .init(top: 0, left: 0, bottom: 0, right: -8)
        }
        return .zero
    }
       
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}
