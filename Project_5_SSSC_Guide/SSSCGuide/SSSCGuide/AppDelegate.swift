//
//  AppDelegate.swift
//  SSSCGuide
//
//  Created by Hasic Dalmir on 30/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let stack = CoreDataStack(modelName: "Model")!
    var hasCheckedIn = false
    var chosenRegion = 0

    func loadRegionsIfNecessary() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("hasLaunchedBefore")) {
            print("App has launched before")
            hasCheckedIn = NSUserDefaults.standardUserDefaults().boolForKey("hasCheckedIn")
            chosenRegion = NSUserDefaults.standardUserDefaults().integerForKey("chosenRegion")
            
            print("initializeing \(hasCheckedIn) \(chosenRegion)")



        }
        else {
            print("This is the first launch!")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLaunchedBefore")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "chosenRegion")
            RegionImporter.sharedInstance().importRegions()


        }
    }
    
    func saveUserPreferences () {
        NSUserDefaults.standardUserDefaults().setBool(hasCheckedIn, forKey: "hasCheckedIn")
        NSUserDefaults.standardUserDefaults().setInteger(chosenRegion, forKey: "chosenRegion")
        
        print("setting \(hasCheckedIn) \(chosenRegion)")

    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        loadRegionsIfNecessary()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveUserPreferences()

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveUserPreferences()
    }


}

