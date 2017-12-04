//
//  AppDelegate.swift
//  AppStoreTransition
//
//  Created by Luke Zhao on 2017-12-04.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = ViewController<FirstView>()
    window!.makeKeyAndVisible()
    return true
  }
}

