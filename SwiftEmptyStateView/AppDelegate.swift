//
//  AppDelegate.swift
//  SwiftEmptyStateView
//
//  Created by 杨志远 on 2019/11/15.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: ExampleMainViewController(nibName: "ExampleMainViewController", bundle: nil))
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        self.window = window
        return true
    }


}

