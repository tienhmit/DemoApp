//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DataManager.shared.fetchData()
        LocalizationStringHelper.setUpDefaultLanguage()
        let _window = UIWindow(frame: UIScreen.main.bounds)
        let vc = WeatherHomePageView.initWithDefaultNib()
        _window.rootViewController = vc
        _window.backgroundColor = .white
        _window.makeKeyAndVisible()
        window = _window
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}

