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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
   
        let vc = LoginViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.navigationBar.isTranslucent = false
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
        return true
    }



}

