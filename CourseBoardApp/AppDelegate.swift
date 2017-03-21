//
//  AppDelegate.swift
//  CourseBoardApp
//
//  Created by Nicholas Swift on 11/7/16.
//  Copyright © 2016 Nicholas Swift. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase
        FIRApp.configure()
        
        // Nav Title
        let attrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15)]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        // Leave on launch screen for a little longer
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchViewController = launchScreen.instantiateViewController(withIdentifier: "LaunchViewController")
        self.window?.rootViewController = launchViewController
        self.window?.makeKeyAndVisible()
        
        // Load in correct view controller
        CourseBoardAPI.alreadyLoggedIn { [unowned self] (bool: Bool) in
            
            // Get storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController: UIViewController!
            
            // Set correct View Controller
            if bool == true {
                viewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
                
                // Load all views first
                for vc in (viewController as! UITabBarController).viewControllers! {
                    let _ = (vc as! UINavigationController).viewControllers[0].view
                }
            }
            else {
                viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            }
            
            // Load it in
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            
        }
        
        return true
    }


}

