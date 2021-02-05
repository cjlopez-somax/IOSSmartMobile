//
//  GpsController.swift
//  SSmartMobile
//
//  Created by Christian on 04-02-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import UIKit
import CoreLocation

class GpsTrackController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var dateNext:Date = GeneralFunctions.getCurrentTime()
    var isUpdateLocation:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocation()
    }
    
    func initLocation(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        //locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let speed = location.speed
        let currentDateTime = GeneralFunctions.getCurrentTime()
        print("\(currentDateTime) - \(latitude) - \(longitude) - \(speed)")
        
        if currentDateTime >= dateNext {
            if isUpdateLocation{
                print("SignificantLocation location")
                locationManager.stopUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
                dateNext = currentDateTime.addingTimeInterval(TimeInterval(60))
            }else{
                print("UpdatingLocation location")
                locationManager.stopMonitoringSignificantLocationChanges()
                setupUpdatingLocation()
                dateNext = currentDateTime.addingTimeInterval(TimeInterval(30))
            }
            isUpdateLocation = !isUpdateLocation
            
        }
    }
    
    func setupUpdatingLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        //locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
}
