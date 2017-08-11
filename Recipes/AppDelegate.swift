//
//  AppDelegate.swift
//  Recipes
//
//  Created by Ulrik Utheim Sverdrup on 01.08.2017.
//  Copyright © 2017 Ulrik Utheim Sverdrup. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("Window not found") }
        
        let navigationController = UINavigationController(rootViewController: RecipiesTableViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return true
    }
}
