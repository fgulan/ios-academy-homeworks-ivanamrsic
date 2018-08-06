//
//  AppDelegate.swift
//  TVShows
//
//  Created by Ivana Mrsic on 05/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationViewController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let token = UserDefaults.standard.value(forKey: "userToken") {
            let homeViewController = HomeViewController()
            homeViewController.userToken = token as? String
            navigationViewController = UINavigationController(rootViewController: homeViewController)
        } else {
            let loginViewController = LoginViewController()
            navigationViewController = UINavigationController(rootViewController: loginViewController)
        }
        
        navigationViewController?.navigationBar.isTranslucent = false
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        return true
    }
}

