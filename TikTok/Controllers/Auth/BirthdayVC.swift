//
//  BirthdayVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 1/20/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class BirthdayVC: UIViewController {
    
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handleSetUpNavItems()
        setUpViews()
        handleSetUpAttributedStrings()
    }
    
    
    //MARK: - Init
    
    
    //MARK: - Properties
    fileprivate var selectedDate: Date? {
        didSet {
            handleValidateNextButton(date: selectedDate)
        }
    }
    
    fileprivate let whenIsYourBirthdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate let selectedBirthdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "Birthday"
        label.font = avenirRomanFont(size: 14.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.addTarget(self, action: #selector(handleDidSelectNextButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    fileprivate lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        return datePicker
    }()
    
    
    //MARK: - Handlers
    fileprivate func handleSetUpNavItems() {
        navigationItem.title = "Sign up"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    
    fileprivate func setUpViews() {
        view.addSubview(whenIsYourBirthdayLabel)
        
        whenIsYourBirthdayLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 30, bottom: 0, right: 0))
        
        view.addSubview(selectedBirthdayLabel)
        selectedBirthdayLabel.anchor(top: whenIsYourBirthdayLabel.bottomAnchor, leading: whenIsYourBirthdayLabel.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 45, left: 0, bottom: 0, right: 0))
        
        view.addSubview(lineSeperatorView)
        lineSeperatorView.anchor(top: selectedBirthdayLabel.bottomAnchor, leading: selectedBirthdayLabel.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 30), size: .init(width: 0, height: 0.8))
        
        
        view.addSubview(nextButton)
        nextButton.anchor(top: lineSeperatorView.bottomAnchor, leading: lineSeperatorView.leadingAnchor, bottom: nil, trailing: lineSeperatorView.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        
        view.addSubview(datePicker)
        datePicker.anchor(top: nil, leading: lineSeperatorView.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: lineSeperatorView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        
        
    }
    
    
    fileprivate func handleSetUpAttributedStrings() {
        
        let attributedText = setupAttributedTextWithFonts(titleString: "When's your birthday?\n", subTitleString: "Your birthday won't be shown publicly", attributedTextColor: .gray, mainColor: .black, mainfont: defaultFont(size: 20), subFont: avenirRomanFont(size: 13.5))
        
        whenIsYourBirthdayLabel.attributedText = attributedText
    }
    
    
    fileprivate func handleValidateNextButton(date: Date?) {
        if date == nil {
            nextButton.isEnabled = false
            nextButton.backgroundColor = baseWhiteColor
            nextButton.setTitleColor(.gray, for: .normal)
            selectedBirthdayLabel.text = "Birthday"
            selectedBirthdayLabel.textColor = .gray

        } else {
            nextButton.isEnabled = true
            nextButton.backgroundColor = tikTokRed
            nextButton.setTitleColor(.white, for: .normal)
            selectedBirthdayLabel.textColor = .black
        }
    }
    
    
    //MARK: - Target Selectors
    

    @objc fileprivate func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        selectedBirthdayLabel.text = dateFormatter.string(from: sender.date)
        selectedDate = sender.date
    }
    
    
    @objc fileprivate func handleDidSelectNextButton() {
        let enterEmailVC = EnterEmailVC(birthdate: datePicker.date)
        navigationController?.pushViewController(enterEmailVC, animated: true)
    }



}
