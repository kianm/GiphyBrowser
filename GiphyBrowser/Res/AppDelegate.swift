//
//  AppDelegate.swift
//  GiphyBrowser
//
//  Created by kian on 6/6/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, InteractionInjected {

    static let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.window.makeKeyAndVisible()
        interaction.setState(.trendingGIFs)
        return true
    }
}
