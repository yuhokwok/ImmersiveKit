//
//  AppDelegate.swift
//  ImmersiveTracker
//
//  Created by Yu Ho Kwok on 22/11/2019.
//  Copyright © 2019 ImmersiveKit Team. All rights reserved.
//

import UIKit

//Global Stuff
var logTextView : UITextView?
var logDateFormatter : DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm:ss"
    return dateFormatter
}()
func printLog(_ msg : String){
    print(msg)
    if let str = logTextView?.text {
        logTextView?.text = "\(logDateFormatter.string(from: Date()))\t:    \(msg)\n\(str)"
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

