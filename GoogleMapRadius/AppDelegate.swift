//
//  AppDelegate.swift
//  GoogleMapRadius
//
//  Created by Inkswipe on 6/4/18.
//  Copyright © 2018 Fortune4 Technologies. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GoogleMaps
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var notificationCenter: UNUserNotificationCenter!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey("AIzaSyAC2MLjxYsAWGJnR3tNmovGFhOA4ymGAUI")
        GMSServices.provideAPIKey("AIzaSyCLx3Wh25rVTz5ZYrYABIlZ9CJYPmtryyw")
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        
        // get the singleton object
        self.notificationCenter = UNUserNotificationCenter.current()
        
        // register as it's delegate
        notificationCenter.delegate = self
        
        // define what do you need permission to use
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        // request permission
        notificationCenter.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Permission not granted")
            }
        }
        
        if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            print("I woke up thanks to geofencing")
        }
        
        
        return true
    }
    func handleEvent1(forRegion region: CLRegion!) {
        
        // customize your notification content
        let content = UNMutableNotificationContent()
        content.title = "Map Triggered Enter"
        content.body = "Am in the region! \(region.identifier)"
        content.sound = UNNotificationSound.default()
        
        // when the notification will be triggered
        let timeInSeconds: TimeInterval = 1
        // the actual trigger object
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInSeconds,
            repeats: false
        )
        
        // notification unique identifier, for this example, same as the region to avoid duplicate notifications
        let identifier = region.identifier
        
        // the notification request object
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // trying to add the notification request to notification center
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }
    func handleEvent(forRegion region: CLRegion!) {
        
        // customize your notification content
        let content = UNMutableNotificationContent()
        content.title = "Map Triggered"
        content.body = "Am in the region! \(region.identifier)"
        content.sound = UNNotificationSound.default()
        
        // when the notification will be triggered
        let timeInSeconds: TimeInterval = 1
        // the actual trigger object
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInSeconds,
            repeats: false
        )
        
        // notification unique identifier, for this example, same as the region to avoid duplicate notifications
        let identifier = region.identifier
        
        // the notification request object
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // trying to add the notification request to notification center
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }
}


extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("The monitored regions are: \(manager.monitoredRegions)")
    }
    
    // called when user Exits a monitored region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent1(forRegion: region)
        }
    }
    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            self.handleEvent1(forRegion: region)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for r in manager.monitoredRegions
        {
            if let cr = r as? CLCircularRegion
            {
                if cr.contains(locations[0].coordinate)
                {
                    self.handleEvent(forRegion: cr)
                }
                else
                {
                    //                    let crLoc = CLLocation(latitude: cr.center.latitude,
                    //                                           longitude: cr.center.longitude)
                    //                    showAlert("distance is \(locations[0].distance(from: crLoc))")
                    
                }
            }
        }
        //showAlert("didUpdateLocations ")
        //updateRegionsWithLocation(locations[0])
    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is onpen and in foregroud
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // get the notification identifier to respond accordingly
        let identifier = response.notification.request.identifier
        
        // do what you need to do
        print(identifier)
        // ...
    }
}




/*
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
 
 let locationManager = CLLocationManager()
 var window: UIWindow?
 
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
 GMSPlacesClient.provideAPIKey("AIzaSyAC2MLjxYsAWGJnR3tNmovGFhOA4ymGAUI")
 GMSServices.provideAPIKey("AIzaSyCLx3Wh25rVTz5ZYrYABIlZ9CJYPmtryyw")
 // Override point for customization after application launch.
 return true
 }
 
 func applicationWillResignActive(_ application: UIApplication) {
 // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
 // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
 }
 
 func applicationDidEnterBackground(_ application: UIApplication) {
 // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
 // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
 }
 
 func applicationWillEnterForeground(_ application: UIApplication) {
 // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
 }
 
 func applicationDidBecomeActive(_ application: UIApplication) {
 // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 }
 
 func applicationWillTerminate(_ application: UIApplication) {
 // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
 // Saves changes in the application's managed object context before the application terminates.
 self.saveContext()
 }
 
 // MARK: - Core Data stack
 
 lazy var persistentContainer: NSPersistentContainer = {
 /*
 The persistent container for the application. This implementation
 creates and returns a container, having loaded the store for the
 application to it. This property is optional since there are legitimate
 error conditions that could cause the creation of the store to fail.
 */
 let container = NSPersistentContainer(name: "GoogleMapRadius")
 container.loadPersistentStores(completionHandler: { (storeDescription, error) in
 if let error = error as NSError? {
 // Replace this implementation with code to handle the error appropriately.
 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
 
 /*
 Typical reasons for an error here include:
 * The parent directory does not exist, cannot be created, or disallows writing.
 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
 * The device is out of space.
 * The store could not be migrated to the current model version.
 Check the error message to determine what the actual problem was.
 */
 fatalError("Unresolved error \(error), \(error.userInfo)")
 }
 })
 return container
 }()
 
 // MARK: - Core Data Saving support
 
 func saveContext () {
 let context = persistentContainer.viewContext
 if context.hasChanges {
 do {
 try context.save()
 } catch {
 // Replace this implementation with code to handle the error appropriately.
 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
 let nserror = error as NSError
 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
 }
 }
 }
 
 }
 
 extension AppDelegate:CLLocationManagerDelegate
 {
 func getCurrentLocaton()  {
 
 locationManager.requestWhenInUseAuthorization();
 if CLLocationManager.locationServicesEnabled() {
 locationManager.delegate = self
 locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
 locationManager.startUpdatingLocation()
 }
 else{
 print("Location service disabled");
 }
 }
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
 print("locations = \(locValue.latitude) \(locValue.longitude)")
 
 //Constant.shared.setCurrentLat(lat: "\(locValue.latitude)")
 //Constant.shared.setCurrentLong(long: "\(locValue.longitude)")
 
 }
 
 }
 
 
 import UIKit
 import CoreLocation
 import UserNotifications

 
 */
