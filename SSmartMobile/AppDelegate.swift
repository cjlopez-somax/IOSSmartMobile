//
//  AppDelegate.swift
//  SSmartMobile
//
//  Created by Christian on 17-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //locationManager.delegate = self
        //locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.startMonitoringSignificantLocationChanges()
        
        // Override point for customization after application launch.
        if(launchOptions?[UIApplication.LaunchOptionsKey.location] != nil) {
            print("Significant is called to relaunch app")
            // handle new location that was sent, but don't launch the rest of the application

        } else {
            print("Launch app not for locationSignificant")
            // do all the regular stuff, such as setting keyWindow etc

        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will killed")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Aplicacion enter to background!!")
    }
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location get coordenates")
    } */
    
}







extension Date {
   func getFormattedDate() -> String {
    let format = "yyyy-MM-dd HH:mm:ss"
    let dateformat = DateFormatter()
    dateformat.timeZone = TimeZone(abbreviation: "UTC")
    dateformat.dateFormat = format
    return dateformat.string(from: self)
    }
    
    func getRFC3339Date() -> String {
     let format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
     let dateformat = DateFormatter()
     dateformat.timeZone = TimeZone(abbreviation: "UTC")
     dateformat.dateFormat = format
     return dateformat.string(from: self)
     }
    
    func getDateTimeZone()-> Date{
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
        let date = Date(timeInterval: seconds, since: self)
        return date;
    }
 
}

