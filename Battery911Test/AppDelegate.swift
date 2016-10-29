//
//  AppDelegate.swift
//  Battery911Test
//
//  Created by Adrian C. Johnson on 10/27/16.
//  Copyright © 2016 Cross Vision Development Studios. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        MagicalRecord.setupAutoMigratingCoreDataStack()
        
        // Comment out to keep existing data
        testData()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Custom Methods
    func testData() {
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext) in
            if let testResultsArray = TestResult.MR_findAll() as? [TestResult] {
                for testResult in testResultsArray {
                    testResult.MR_deleteEntityInContext(localContext)
                }
            }
        }
        
        TestResult.createTestResultWithPatientName("James Petterson", hasMigraines: true, age: 20, gender: "Male", usedHallucinogenicDrugs: false, completion: nil, failure: nil)
        TestResult.createTestResultWithPatientName("Chris Hale", hasMigraines: true, age: 15, gender: "Male", usedHallucinogenicDrugs: true, completion: nil, failure: nil)
        TestResult.createTestResultWithPatientName("Chloe Johnson", hasMigraines: false, age: 30, gender: "Female", usedHallucinogenicDrugs: false, completion: nil, failure: nil)
        TestResult.createTestResultWithPatientName("Emilee Franklin", hasMigraines: true, age: 44, gender: "Female", usedHallucinogenicDrugs: true, completion: nil, failure: nil)
        TestResult.createTestResultWithPatientName("Seth Brown", hasMigraines: false, age: 8, gender: "Male", usedHallucinogenicDrugs: false, completion: nil, failure: nil)
        TestResult.createTestResultWithPatientName("John Smith", hasMigraines: true, age: 11, gender: "Male", usedHallucinogenicDrugs: false, completion: nil, failure: nil)
    }
}

