//
//  CreatePostVC.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 10/29/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Photos
import AVKit
import AVFoundation
fileprivate let cameraCellReuseIdentifier = "cameraCellReuseIdentifier"
fileprivate let templatesCellReuseIdentifier = "templatesCellReuseIdentifier"
fileprivate let headerReuseIdentifier = "headerReuseIdentifier"
fileprivate let footerReuseIdentifier = "footerReuseIdentifier"
class CreatePostVC: UIViewController {
    
    //
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpViews()
        
        view.addSubview(segPro)
        segPro.anchor(top: progressView.topAnchor, leading: progressView.leadingAnchor, bottom: nil, trailing: progressView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 6)) //0.25
        progressView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

    }
    
    let segPro = SegmentedProgressView()

    
    @objc func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        segPro.shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
       super.viewDidDisappear(animated)
       //MARK: - Remove before uploading to firebase
       stopSession()
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if setUpSession() {
            perform(#selector(startSession), with: nil, afterDelay: 0.1)
        }
    }
    
    
    //MARK: - Properties
    override var prefersStatusBarHidden: Bool {
         return true
     }
    
    
    
    fileprivate var thumbnailImage: UIImage?
    fileprivate var currentMaxRecordingDuration: CGFloat = 15
    let photoOutput = AVCapturePhotoOutput()
    let movieOutput = AVCaptureMovieFileOutput()
    let captureSession = AVCaptureSession()
    var flashMode: Bool = false
    var autoflashMode: Bool = false
    var activeInput: AVCaptureDeviceInput!
    var outPutURL: URL!
    fileprivate var timeMin = 0
    fileprivate var timeSec = 0
    fileprivate weak var recordingTimer: Timer?

    
    
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentCameraDevice: AVCaptureDevice?
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    fileprivate let captureButtonDimension: CGFloat = 68

    
   let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.2) //0.5
        progressView.progressTintColor = snapchatBlueColor
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 2
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2.8)
        return progressView
    }()
    
    
    
    
    
     let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(cancelIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()

    
    let createPostMenuBar: CreatePostMenuBar = {
        let createPostMenuBar = CreatePostMenuBar()
        return createPostMenuBar
    }()
    
    
    let effectsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(effectsIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

           
   lazy var captureButton: UIButton = {
       let button = UIButton(type: .system)
       button.backgroundColor = UIColor.rgb(red: 254, green: 44, blue: 85)
       button.clipsToBounds = true
       button.layer.cornerRadius = captureButtonDimension / 2
       button.addTarget(self, action: #selector(handleDidTapRecordButton), for: .touchUpInside)
       return button
   }()
    
    
    let captureButtonRingView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.rgb(red: 254, green: 44, blue: 85).withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 6
        view.layer.cornerRadius = 85 / 2
        view.clipsToBounds = true
        return view
    }()

    
    
    lazy var discardRecordingButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(discardIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(self, action: #selector(handleDidTapDiscardButton), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate let saveRecordingButtonDimension: CGFloat = 35
    
    lazy var saveRecordingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = tikTokRed
        button.tintColor = .white
        button.setImage(saveVideoCheckmarkIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.layer.cornerRadius = saveRecordingButtonDimension / 2
        button.alpha = 0
        button.constrainHeight(constant: saveRecordingButtonDimension)
        button.constrainWidth(constant: saveRecordingButtonDimension)
        button.addTarget(self, action: #selector(handlePreviewCapturedVideo), for: .touchUpInside)
        return button
    }()
        
    
    let rightGuildeLineView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
//        view.backgroundColor = .red
        return view
    }()
    
    
    let leftGuildeLineView: UIView = {
       let view = UIView()
//       view.backgroundColor = .red
       return view
   }()
    
    
    lazy var openMediaPickerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOpenMediaPicker))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
       return view
   }()

   lazy var openMediaPickerButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(landscapeIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
       button.addTarget(self, action: #selector(didTapOpenMediaPicker), for: .allTouchEvents)
       return button
   }()
    
    
    let effectsLabel: UILabel = {
        let label = UILabel()
        label.text = "Effects"
        label.font = defaultFont(size: 12.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var uploadLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload"
        label.font = defaultFont(size: 12.5)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOpenMediaPicker))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    
    lazy var revertCameraDirectionButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "flipCameraIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.constrainWidth(constant: 30)
        button.constrainHeight(constant: 30)
        button.addTarget(self, action: #selector(toggleCameraPosition), for: .touchUpInside)
        return button
    }()
       
    
    fileprivate let recordingTimeLabel: UILabel = {
           let label = UILabel()
           label.textColor = .white
           label.text = "00:00"
           return label
       }()
       
        
    
    //MARK: - Handlers
    fileprivate func setUpViews() {
        let padding: CGFloat = 17.5
        view.addSubview(progressView)
        progressView.constrainToTop(paddingTop: 12)
        progressView.centerXInSuperview()
        progressView.constrainWidth(constant: view.frame.width - padding)
        
        
       
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 12, bottom: 0, right: 0), size: .init(width: 30, height: 30))
        
        view.addSubview(createPostMenuBar)
        createPostMenuBar.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, size: .init(width: view.frame.width, height: 50))
        createPostMenuBar.centerXInSuperview()
        
        
        view.addSubview(captureButtonRingView)
         
        captureButtonRingView.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 65, right: 0), size: .init(width: 85, height: 85))
         captureButtonRingView.centerXInSuperview()
         
         view.addSubview(captureButton)
         captureButton.centerXAnchor.constraint(equalTo: captureButtonRingView.centerXAnchor).isActive = true
         captureButton.centerYAnchor.constraint(equalTo: captureButtonRingView.centerYAnchor).isActive = true
         captureButton.constrainHeight(constant: captureButtonDimension)
         captureButton.constrainWidth(constant: captureButtonDimension)

         
        view.addSubview(rightGuildeLineView)
        rightGuildeLineView.anchor(top: captureButtonRingView.topAnchor, leading: captureButtonRingView.trailingAnchor, bottom: captureButtonRingView.bottomAnchor, trailing: view.trailingAnchor)
         
        view.addSubview(leftGuildeLineView)
        leftGuildeLineView.anchor(top: captureButtonRingView.topAnchor, leading: view.leadingAnchor, bottom: captureButtonRingView.bottomAnchor, trailing: captureButtonRingView.leadingAnchor)
         
         rightGuildeLineView.addSubview(openMediaPickerButton)
         openMediaPickerButton.centerInSuperview()

        view.addSubview(openMediaPickerView)
        openMediaPickerView.centerYAnchor.constraint(equalTo: openMediaPickerButton.centerYAnchor).isActive = true
        openMediaPickerView.centerXAnchor.constraint(equalTo: openMediaPickerButton.centerXAnchor).isActive = true

        openMediaPickerView.constrainHeight(constant: 70)
        openMediaPickerView.constrainWidth(constant: 60)

         
         leftGuildeLineView.addSubview(effectsButton)
         effectsButton.centerInSuperview()
         
         rightGuildeLineView.addSubview(uploadLabel)
         uploadLabel.topAnchor.constraint(equalTo: openMediaPickerButton.bottomAnchor, constant: 2.5).isActive = true
         uploadLabel.centerXAnchor.constraint(equalTo: openMediaPickerButton.centerXAnchor).isActive = true

         
         
        leftGuildeLineView.addSubview(effectsLabel)
         effectsLabel.topAnchor.constraint(equalTo: effectsButton.bottomAnchor, constant: 2.5).isActive = true
        effectsLabel.centerXAnchor.constraint(equalTo: effectsButton.centerXAnchor).isActive = true

        
        view.addSubview(revertCameraDirectionButton)
        revertCameraDirectionButton.anchor(top: cancelButton.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12))

        
        let save_discardButtonsStacView = UIStackView(arrangedSubviews: [discardRecordingButton, saveRecordingButton])
        save_discardButtonsStacView.axis = .horizontal
        save_discardButtonsStacView.distribution = .fillEqually
        rightGuildeLineView.addSubview(save_discardButtonsStacView)
        save_discardButtonsStacView.constrainHeight(constant: saveRecordingButtonDimension)
        save_discardButtonsStacView.constrainWidth(constant: 100)
        save_discardButtonsStacView.centerInSuperview()
        
        
//        view.addSubview(recordingTimeLabel)
//        recordingTimeLabel.centerInSuperview()
//         
        handleSetUpDevices()
        
        if setUpSession() {
            perform(#selector(startSession), with: nil, afterDelay: 0.3)
        }
        
    }
    
    
    
    @objc fileprivate func didTapOpenMediaPicker() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let mediaPickerVC = MediaPickerVC(collectionViewLayout: layout)
        mediaPickerVC.mediaPickerWasClosedDelegate = self
        let navController = UINavigationController(rootViewController: mediaPickerVC)
        present(navController, animated: true, completion: nil)
        stopSession()

//        print("didTapOpenMediaPicker")
    }
    
    
    
    @objc fileprivate func handleDidTapDiscardButton() {
        let alertVC = UIAlertController(title: "Discard the last clip?", message: nil, preferredStyle: .alert)
        let discardAction = UIAlertAction(title: "Discard", style: .default) {[weak self] (_) in
//            print("handleDidTapDiscardButton:", "Discard")
            self?.handleDiscardLastRecordedClip()
        }
        let keepAction = UIAlertAction(title: "Keep", style: .cancel) { (_) in
//            print("handleDidTapDiscardButton:", "Keep")
        }
        alertVC.addAction(discardAction)
        alertVC.addAction(keepAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    
    
    @objc fileprivate func handleDiscardLastRecordedClip() {
        FileManager.default.clearTmpDirectory()
        outPutURL = nil
        thumbnailImage = nil
        progressView.setProgress(0, animated: true)
        handleResetAllVisibilityToIdentity()
    }
    
    
    @objc func handleResetAllVisibilityToIdentity() {
        [discardRecordingButton, saveRecordingButton].forEach { (subView) in
            subView.alpha = 0
        }
        
        [self.createPostMenuBar, self.effectsLabel, self.effectsButton, self.uploadLabel, self.openMediaPickerButton, self.openMediaPickerView, self.revertCameraDirectionButton, self.cancelButton].forEach { (subView) in
            subView.isHidden = false
        }
        
        if setUpSession() {
            perform(#selector(startSession), with: nil, afterDelay: 0.1)
        }
    }
    
    @objc fileprivate func handleDismiss() {
        FileManager.default.clearTmpDirectory()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @objc fileprivate func handlePreviewCapturedVideo() {
        if let thumbnailImageUnwrapped = thumbnailImage, let cameraPosition = currentCameraDevice?.position {
            let previewVC = PreviewCapturedVideoVC(videoURLFromTempDirectory: outPutURL, thumbnailImage: thumbnailImageUnwrapped, cameraPosition: cameraPosition)
            navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
    
    @objc fileprivate func handleDidTapRecordButton() {
        handleAnimateRecordButton()
        startRecording()
    }
    
    var isRecording = false
    fileprivate func handleAnimateRecordButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {[weak self] in
             guard let self = self else {return}
             if self.isRecording == false {
               self.captureButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
               self.captureButton.layer.cornerRadius = 5
               self.captureButtonRingView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                
                self.saveRecordingButton.alpha = 0
                self.discardRecordingButton.alpha = 0

                [self.createPostMenuBar, self.effectsLabel, self.effectsButton, self.uploadLabel, self.openMediaPickerButton, self.openMediaPickerView, self.revertCameraDirectionButton, self.cancelButton].forEach { (subView) in
                    subView.isHidden = true
                }

             } else {
                
               self.captureButton.transform = CGAffineTransform.identity
               self.captureButton.layer.cornerRadius = self.captureButtonDimension / 2
               self.captureButtonRingView.transform = CGAffineTransform.identity
                
               self.discardRecordingButton.alpha = 1

               [self.createPostMenuBar, self.effectsLabel, self.effectsButton, self.revertCameraDirectionButton, self.cancelButton].forEach { (subView) in
                    subView.isHidden = false
                }
             }
        }) {[weak self] (onComplete) in
            guard let self = self else {return}
            self.isRecording = !self.isRecording
        }
      }
    
    
    @objc func toggleCameraPosition() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {[weak self] in
            self?.revertCameraDirectionButton.flipX()
        })
        
          captureSession.beginConfiguration()
          guard let newDevice = (currentCameraDevice?.position == .back) ? frontFacingCamera : backFacingCamera else {return}
          
          //1. Remove all current inputs in capture session
          for input in captureSession.inputs {
              captureSession.removeInput(input as! AVCaptureDeviceInput)
          }
          
          
          //2. SetUp Camera
          do {
              let input = try AVCaptureDeviceInput(device: newDevice)
              if captureSession.canAddInput(input) {
                  captureSession.addInput(input)
                  activeInput = input
                  
              }
              
              
          } catch let inputError {
              print("Error setting device video input\(inputError)")
          }
          
          
          //3. Set up mic
          if let microphone = AVCaptureDevice.default(for: .audio) {
              
              do {
                  let micInput = try AVCaptureDeviceInput(device: microphone)
                  if captureSession.canAddInput(micInput) {
                      captureSession.addInput(micInput)
                      
                  }
                  
              } catch let micInputError {
                  print("Error setting device audio input\(micInputError)")
              }
          }
          
          
          
          currentCameraDevice = newDevice
          captureSession.commitConfiguration()
          
      }
    
    
    //MARK: - Code Was Created by SamiSays11. Copyright © 2019 SamiSays11 All rights reserved.
}



extension CreatePostVC: AVCaptureFileOutputRecordingDelegate {
   
    //MARK: - SetUp Session
       func setUpSession() -> Bool {
           
           captureSession.sessionPreset = AVCaptureSession.Preset.high
           
           
           //1. SetUp Camera
           if let currentCameraUnwrapped = currentCameraDevice {
               do {
                   let input = try AVCaptureDeviceInput(device: currentCameraUnwrapped)
                   if captureSession.canAddInput(input) {
                       captureSession.addInput(input)
                       activeInput = input
                       
                   }
                   
               } catch let inputError {
                   print("Error setting device video input\(inputError)")
                   return false
               }
               
           }
           
           
           //2. Set up mic
           if let microphone = AVCaptureDevice.default(for: .audio) {
               
               do {
                   let micInput = try AVCaptureDeviceInput(device: microphone)
                   if captureSession.canAddInput(micInput) {
                       captureSession.addInput(micInput)
                       
                   }
                   
               } catch let micInputError {
                   print("Error setting device audio input\(micInputError)")
                   return false
               }
           }
           
           
           
           //3. Movie Recorded OutPut
           if captureSession.canAddOutput(movieOutput) {
               captureSession.addOutput(movieOutput)
           }
           
           
           //3. Photo Captured Output
           if captureSession.canAddOutput(photoOutput) {
               photoOutput.isHighResolutionCaptureEnabled = true
               captureSession.addOutput(photoOutput)
           }

           
           //4. setup output preview
           //        previewLayer.isHidden = true

           
           previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
           previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
           view.layer.insertSublayer(previewLayer, below: progressView.layer)
           return true
       }
    
    
    
    
    func handleSetUpDevices() {
        //only builtInWideAngleCamera worked so i had to add mic seperately
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInMicrophone, .builtInWideAngleCamera, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: .video, position: .unspecified).devices
        
        for device in devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
                
            }
        }
        
        //default
        currentCameraDevice = backFacingCamera
        
    }
    
    
    
    
    //MARK:- Camera Session
       @objc func startSession() {
           
           if !captureSession.isRunning {
               videoQueue().async {
                   self.captureSession.startRunning()
               }
           }
       }
       
       
       
       func stopSession() {
           if captureSession.isRunning {
               videoQueue().async {
                   self.captureSession.stopRunning()
               }
           }
       }
       
       
       
       func videoQueue() -> DispatchQueue {
           return DispatchQueue.main
           
       }
    
    
    
    func tempURL() -> URL? {
           let directory = NSTemporaryDirectory() as NSString
           
           if directory != "" {
               let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
               return URL(fileURLWithPath: path)
           }
           
           return nil
       }
    
    
    
    func startRecording() {
        if movieOutput.isRecording == false {
            guard let connection = movieOutput.connection(with: .video) else {return}
            if (connection.isVideoOrientationSupported) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
                
                let device = activeInput.device
                if (device.isSmoothAutoFocusSupported) {
                    do {
                        try device.lockForConfiguration()
                        device.isSmoothAutoFocusEnabled = false
                        device.unlockForConfiguration()
                    } catch {
                        print("Error setting configuration: \(error)")
                    }
                    
                }
                
                outPutURL = tempURL()
                movieOutput.startRecording(to: outPutURL, recordingDelegate: self)
                progressView.progress = 0


            }
        } else {
            stopRecording()
        }
    }
    
    
    func stopRecording() {
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
            stopTimer()
            saveRecordingButton.alpha = 1
            print("STOP THE COUNT!!!")
        }
    }
    
    
    
    //MARK: - AVCaptureFileOutputRecordingDelegate
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        //
        print("recording now")
        startTimer()
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error?.localizedDescription ?? "")")
        } else {
            ///at this point we do not have access to the phhasset yet because its yet to be created, however we do have access to the temp url and we can generate a thumbnail from that using AVAssetImageGenerator. we generate the real asset to be exported to DB later in the mediaPreviewView itsself upon setting the URL setter
            let urlOfVideoRecorded = outPutURL! as URL
            guard let generatedThumbnailImage = generateVideoThumbnail(withfile: urlOfVideoRecorded) else {return}
            if currentCameraDevice?.position == .front {
                //if front camera we mirror the thumbnail image, else keep the same orientation the same
                thumbnailImage = didTakePicture(generatedThumbnailImage, to: .upMirrored)
            } else {
                thumbnailImage = generatedThumbnailImage
            }
        }
    }
       
    
    
    
    
    
    ////MARK: - Recording Timer
    fileprivate func startTimer(){
        // if you want the timer to reset to 0 every time the user presses record you can uncomment out either of these 2 lines
        
         timeSec = 0
        // timeMin = 0
        
        // If you don't use the 2 lines above then the timer will continue from whatever time it was stopped at
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        
        recordingTimeLabel.text = timeNow
        
        stopTimer() // stop it at it's current time before starting it again
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerTick()
        }
    }
    
    
    @objc fileprivate func timerTick(){
        timeSec += 1
        if timeSec == 60 {
            timeSec = 0
            timeMin += 1
            stopRecording()
        }
        
        
        if timeSec == 15 {
            handleDidTapRecordButton()
        }
        
        let timeNow = String(format: "%02d:%02d", timeMin, timeSec)
        recordingTimeLabel.text = timeNow
        
        //this workks as well but the animation is slightly jumpy - S.B
//       let startTime = 0
//       let trimmedTime: Int = Int(currentMaxRecordingDuration)  - startTime
//       let positiveOrZero = max(timeSec, 0) //makes sure it doesnt go below 0 i.e no negative readings
//       progressView.setProgress(Float(positiveOrZero) / Float(trimmedTime), animated: true)
        UIView.animate(withDuration: TimeInterval(currentMaxRecordingDuration), animations: {[weak self] () -> Void in
            self?.progressView.setProgress(1.0, animated: true)
        })
    }
    
    // resets both vars back to 0 and when the timer starts again it will start at 0
    @objc fileprivate func resetTimerToZero(){
        timeSec = 0
        timeMin = 0
        stopTimer()
        recordingTimeLabel.text = String(format: "%02d:%02d", timeMin, timeSec)
    }
    
    // if you need to reset the timer to 0 and yourLabel.txt back to 00:00
    @objc  func resetTimerAndLabel(){
        resetTimerToZero()
        recordingTimeLabel.text = String(format: "%02d:%02d", timeMin, timeSec)
    }
    
    // stops the timer at it's current time
    @objc  func stopTimer(){
        recordingTimer?.invalidate()
        
    }
       
}



//MARK: - MediaPickerWasClosedDelegate
extension CreatePostVC: MediaPickerWasClosedDelegate {
    func didTapCloseMediaPicker() {
        if setUpSession() {
            perform(#selector(startSession), with: nil, afterDelay: 0.1)
        }
    }
}
