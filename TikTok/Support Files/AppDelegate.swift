//
//  AppDelegate.swift
//  NudeFilterML
//
//  Created by Osaretin Uyigue on 8/22/20.
//  Copyright © 2020 Osaretin Uyigue. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        window = UIWindow()
       window?.makeKeyAndVisible()
       window?.clipsToBounds = true
       window?.layer.cornerRadius = 6
//       window?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] //layerMinXMinYCorner = top left, layerMaxXMinYCorner = top left
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: defaultFont(size: 18)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        
       let rootViewController = MainTabBarController()
       window?.rootViewController = rootViewController
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().barTintColor = UIColor.white
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

