//
//  VideoCacheManager.swift
//  Grinn Lens
//
//  Created by Osaretin Uyigue on 11/14/19.
//  Copyright © 2019 Osaretin Uyigue. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(NSError)
}

class CacheManager {
    
    static let shared = CacheManager()
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {
        
        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {
        
        let file = directoryFor(stringUrl: stringUrl)
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            print("this video exists in cache:", file.path)
            completionHandler(Result.success(file))
            return
        }
        
        print("this video does not exist in cache we had to download it:", file.path)
        DispatchQueue.global().async {
            
            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)
                DispatchQueue.main.async {
                    completionHandler(Result.success(file))

                }
            } else {
                DispatchQueue.main.async {
                    let error = NSError(domain: "SomeErrorDomain", code: -2001 /* some error code */, userInfo: ["description": "Can't download video"])
                    print("there was an error:", error.localizedDescription)
                    completionHandler(Result.failure(error))
                }
            }
        }
    }
    
    
    
    private func directoryFor(stringUrl: String) -> URL {
        let fileURL = URL(string: stringUrl)!.lastPathComponent
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        return file
    }
    
    
    //delete Not working yet
//    func deleteFileWith(stringUrl: String) {
//        guard let url = URL(string: stringUrl) else {return}
//
//        do {
//            try FileManager.default.removeItem(at: url)
//            print("successfully deleted url:", url.path)
//        } catch let error {
//            print("Failed to delete url\(url.path) from FileManager.default:", error.localizedDescription)
//
//        }
//
//    }
    
}
