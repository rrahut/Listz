//
//  AppDelegate.swift
//  Listz
//
//  Created by Rajarshi Rahut on 8/11/19.
//  Copyright © 2019 Rajarshi Rahut. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print("didFinishLaunchingWithOptions")
        print("Realm Path : \(Realm.Configuration.defaultConfiguration.fileURL!)")
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: Item.className()) { oldObject, newObject in
                        newObject?["dateCreated"] = Date()
                    }
                } else if oldSchemaVersion == 1 {
                    migration.enumerateObjects(ofType: Category.className(), { (oldCat, newCat) in
                        newCat?["cellColor"] = UIColor.randomFlat().hexValue()
                    })
                }
        }
        )
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //print("applicationWillTerminate")
        //self.saveContext()
    }

    // MARK: - Core Data stack
    
//    lazy var persistentContainer: NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "DataModel")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    // MARK: - Core Data Saving support
    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}

