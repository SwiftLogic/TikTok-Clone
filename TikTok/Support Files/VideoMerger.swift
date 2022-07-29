//
//  VideoMerger.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 3/26/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import AVFoundation
import UIKit

class VideoCompositionWriter: NSObject {
    var exportSession: AVAssetExportSession?

    func mergeMultipleVideo(urls: [URL], onComplete: @escaping (Bool, URL?) -> Void) {
        // Start by creating an asset from each of the url
        // Keep track of the total duration of all these clips combined
        // This will be used to determine the length of the audio in our composition
        
        var totalDuration = CMTime.zero
        var assets: [AVAsset] = []
        
        for url in urls {
         let asset = AVAsset(url: url)
            assets.append(asset)
            totalDuration = CMTimeAdd(totalDuration, asset.duration)
        }
        
        
        // Use our merge function to get a new composition containing all the video clips
        let mixComposition = merge(arrayVideos: assets)
        //output url destination
        let outputURL = createOutPutUrl(with: urls.first!)
        
        handleCreateExportSession(outputURL: outputURL, mixComposition: mixComposition, onComplete: onComplete)
       
    }
    
    
    
    
    func handleCreateExportSession(outputURL: URL, mixComposition: AVMutableComposition, onComplete: @escaping (Bool, URL?) -> Void) {
        // Create an AVAssetExportSession, passing in our composition
        //Step 5 Export: Optimize for networkUse, encode video format to mp4, trim video
        exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = outputURL
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.outputFileType = AVFileType.mp4
        
        //Last Step use timer to broadcast notification progress of our export
        var exportProgressBarTimer = Timer() // initialize timer
            guard let exportSessionUnwrapped = exportSession else { exportProgressBarTimer.invalidate()
                return }
            //withTimeInterval: 0.1
            exportProgressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                // Get Progress
                
                let progress = Float((exportSessionUnwrapped.progress));
                let dict:[String: Float] = ["progress": progress]
                
                NotificationCenter.default.post(name: Notification.Name(LISTEN_FOR_VIDEO_PROCESSING_PROGRESS), object: nil, userInfo: dict)
            }
        
        
        guard let exportSession = exportSession else { exportProgressBarTimer.invalidate()
            return }
        exportSession.exportAsynchronously {
            exportProgressBarTimer.invalidate(); // remove/invalidate timer
            switch exportSession.status {
            case .completed:
                DispatchQueue.main.async {
                    //upon completion set progress to 1 (meaning 100% done)
                    let dict:[String: Float] = ["progress": 1.0]
                    NotificationCenter.default.post(name: Notification.Name(LISTEN_FOR_VIDEO_PROCESSING_PROGRESS), object: nil, userInfo: dict)
                    onComplete(true, exportSession.outputURL)
                }
                
            case .failed:
                print("failed \(exportSession.error.debugDescription)")
                onComplete(false, nil)
                
            case .cancelled:
                print("cancelled \(exportSession.error.debugDescription)")
                onComplete(false, nil)
            default: break
            }
        }

    }
    
    
    func createOutPutUrl(with videoURL: URL) -> URL  {
    
        //Step 1 create temp directory to download the video into
        let fileManager = FileManager.default
        let documentDirectory = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(videoURL.lastPathComponent)")
        }catch let error {
            print(error)
        }
        return outputURL
    }
    
    
    
    func merge(arrayVideos: [AVAsset]) -> AVMutableComposition {
        
        // Create a new mutable compositon
        let mainComposition = AVMutableComposition()
        // Add a video track to the composition
        let compositionVideoTrack = mainComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        // Add audio track to composition
        let compositionAudioTrack = mainComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        //TODO: - fix video track prefered transforms. Determine if video is front or back camera and then mirror accordingly
        let frontCameraTransform: CGAffineTransform = CGAffineTransform(scaleX: -1.0, y: 1.0).rotated(by: CGFloat(Double.pi/2))
        let backCameraTransform: CGAffineTransform = CGAffineTransform(rotationAngle: .pi / 2)

        compositionVideoTrack?.preferredTransform = backCameraTransform
        // Starting at time = 0, loop over each video asset and add them to the track
        var insertTime = CMTime.zero
        for videoAsset in arrayVideos {
            try! compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .video)[0], at: insertTime)
            // Update the next insert time by the video asset's duration
            
            //for check to make sure that videoAsset actually has audio before trying to append, if not it will crash
            if videoAsset.tracks(withMediaType: AVMediaType.audio).count > 0 {
                try! compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .audio)[0], at: insertTime)
            }
            
            insertTime = CMTimeAdd(insertTime, videoAsset.duration)
        }
        return mainComposition
    }
    
    
    
   

   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    // This function takes the path to a directory containing the video clips, an output filenname and an array of filenames identifying the clips to be merged
    func mergeAudioVideo(_ documentsDirectory: URL, filename: String, clips: [String], completion: @escaping (Bool, URL?) -> Void) {
        // Start by creating an asset from each of the clips' filenames
        // Keep track of the total duration of all these clips combined
        // This will be used to determine the length of the audio in our composition
        var assets: [AVAsset] = []
        var totalDuration = CMTime.zero

        for clip in clips {
            let videoFile = documentsDirectory.appendingPathComponent(clip)
            let asset = AVURLAsset(url: videoFile)
            assets.append(asset)
            totalDuration = CMTimeAdd(totalDuration, asset.duration)
        }

        // Use our merge function to get a new composition containing all the video clips
        let mixComposition = merge(arrayVideos: assets)

        // We hardcoded one local audio file for this example, but you can pass a URL to any audio file
        // Load the audio track
        guard let audioUrl = Bundle.main.url(forResource: "Some_Audio_File", withExtension: "mp3") else { return }
        let loadedAudioAsset = AVURLAsset(url: audioUrl)
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: 0)
        do {
            // Insert the audio track into the composition
            try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero,
                                                            duration: totalDuration),
                                            of: loadedAudioAsset.tracks(withMediaType: AVMediaType.audio)[0],
                                            at: CMTime.zero)
        } catch {
            print("Failed to insert audio track")
        }

        // Get path to the output file
        let url = documentsDirectory.appendingPathComponent("out_\(filename)")

        // Create an AVAssetExportSession, passing in our composition
        guard let exporter = AVAssetExportSession(asset: mixComposition,
                                                  presetName: AVAssetExportPresetHighestQuality) else {
            return
        }
        // Set the export session's output URL
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true

        // Carry out the export
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                if exporter.status == .completed {
                    completion(true, exporter.outputURL)
                } else {
                    completion(false, nil)
                }
            }
        }
    }
}



