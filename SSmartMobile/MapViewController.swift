//
//  MapViewController.swift
//  SSmartMobile
//
//  Created by Christian on 26-01-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var dateStartLocation: Date?
    private var dateEndLocation:Date?
    
    private let regionInMeters:Double = 500
    private var gpsMatrix = [GpsInfo] ()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        print("View on Map ready")
        super.viewDidLoad()
        checkLocationServices()
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            initLocation()
            print("after init location")
            checkLocationAuthorization()
        }else{
            // show Alert turn on gps
        }
    }
    
    func checkLocationAuthorization(){
        print("Code status: \(CLLocationManager.authorizationStatus())")
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,
             .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .restricted:
            break
        default:
            print("enter to default")
            break
        }
    }
    
    func centerViewOnUserLocation(){
        print("on centerViewOnUserLocation is called")
        if let location = locationManager.location?.coordinate {
            print("enter to if location")
            let region = MKCoordinateRegion.init(center:location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func initLocation(){
        print("Iniciar Location")
        dateStartLocation = getCurrentTime()
        getEndTimeGps()
        print("Date Start Location: \(dateStartLocation as Any)")
        print("Date End Location: \(dateEndLocation as Any)")
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func getCurrentTime() -> Date{
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
        let date = Date(timeInterval: seconds, since: Date())
        return date
    }
    
    
    func getEndTimeGps(){
        let timeGps = ConfigUtil().getTimeGps()
        self.dateEndLocation = self.dateStartLocation?.addingTimeInterval(TimeInterval(timeGps))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            
            
            let currentDateTime = getCurrentTime()
            
            
            print("latitude: \(latitude ) - longitude: \(longitude)")
            
            if currentDateTime < self.dateStartLocation!{
                print("current is less")
                return
            }
            
            let gpsInfo = GpsInfo(latitude: latitude, longitude: longitude, dateTime: currentDateTime)
            self.gpsMatrix.append(gpsInfo)
            if currentDateTime >= self.dateEndLocation!{
                print("Diference is less")
                let gpsData = GpsData(gpsMatrix: self.gpsMatrix, dateTimeStart: self.dateStartLocation, dateTimeEnd: self.dateEndLocation)
                
                let timeInterval = ConfigUtil().getTimeIntervalGPS()
                print("timeInterval: \(timeInterval)")
                self.dateStartLocation = currentDateTime.addingTimeInterval(TimeInterval(timeInterval))
                getEndTimeGps()
                GpsController().post(gpsData: gpsData)
                self.gpsMatrix.removeAll()
            }
            
            
        }
    }

}
