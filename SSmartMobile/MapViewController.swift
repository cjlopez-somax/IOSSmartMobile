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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    private var locationManager = CLLocationManager()
    private var dateStartLocation: Date?
    private var dateEndLocation:Date?
    
    private var lastDDDate:Date = VariablesUtil.getLastDateDetection()
    private var isGpsUpdatingForServer:Bool = false
    
    private let regionInMeters:Double = 500
    private var gpsMatrix = [GpsInfo] ()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detectDriveView: UIView!
    @IBOutlet weak var loadingStateDD: UIActivityIndicatorView!
    
    @IBOutlet weak var labelCountGps: UILabel!
    private var maxCountGps = 5
    private let currentCountGps = 1
    
    override func viewDidLoad() {
        print("View on Map ready")
        super.viewDidLoad()
        
        checkLocationServices()
        
        setupViewDetectDrive()
        loadingStateDD.hidesWhenStopped = true
        loadingStateDD.startAnimating()
        
        let countGpsString = "\(currentCountGps)/\(maxCountGps)"
        labelCountGps.text = countGpsString
        mapView.delegate = self
        
        let isSameDay = Calendar.current.isDate(self.lastDDDate, inSameDayAs: GeneralFunctions.getCurrentTime())
        print("isSameDay: \(isSameDay)")
        if !isSameDay {
            VariablesUtil.resetVariables()
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion.init(center:userLocation.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
      }
    
    func setupViewDetectDrive(){
            detectDriveView.layer.cornerRadius = 20
            detectDriveView.layer.opacity = 0.7
            detectDriveView.layer.borderWidth = 3
            detectDriveView.layer.borderColor = UIColor.white.cgColor
            detectDriveView.layer.shadowColor = UIColor.black.cgColor
            detectDriveView.layer.shadowRadius = 5
            detectDriveView.layer.shadowOpacity = 0.7
            detectDriveView.layer.shadowOffset = CGSize(width: 5, height: 5)
            detectDriveView.layer.backgroundColor = "#141d47".color.cgColor
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
            startMySignificantLocationChanges()
            //locationManager.startUpdatingLocation()
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
        print("Date Start Location: \(dateStartLocation as Any)")
        print("Date End Location: \(dateEndLocation as Any)")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            print("Device does not support service for SignificantChangeMonitoring")
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
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
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
       let location = locations.last!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("latitude: \(latitude ) - longitude: \(longitude)")
        let currentDateTime = getCurrentTime()
        
        if !self.isGpsUpdatingForServer {
            
            if checkSleepDay() ||
                checkSleepTime() ||
                checkDetectDrive3() ||
                checkGpsDaily() ||
                checkDD1Limit() ||
                checkDD2Limit(){
                print("return on check")
                return
            }
            print("lastDDDate: \(lastDDDate)")
            if currentDateTime >= self.lastDDDate{
                print("lastDDDate es mayor")
                
                locationManager.stopMonitoringSignificantLocationChanges()
                locationManager.startUpdatingLocation()
                
                
                VariablesUtil.addGpsAccessTimes()
                
                isGpsUpdatingForServer = true
                
                let timeInterval = ConfigUtil().getTimeInterval()
                print("timeInterval: \(timeInterval)")
                self.lastDDDate = currentDateTime.addingTimeInterval(TimeInterval(timeInterval))
                VariablesUtil.setLastDateDetection(date:self.lastDDDate)
                
                
                dateStartLocation = getCurrentTime()
                getEndTimeGps()
                
            }
            
            return
        }
        
        print("recolectando datos")
        let gpsInfo = GpsInfo(latitude: latitude, longitude: longitude, dateTime: currentDateTime)
        self.gpsMatrix.append(gpsInfo)
        if currentDateTime >= self.dateEndLocation!{
            print("Diference is less")
            let gpsData = GpsData(gpsMatrix: self.gpsMatrix, dateTimeStart: self.dateStartLocation, dateTimeEnd: self.dateEndLocation)
            
            GpsController().post(gpsData: gpsData)
            self.gpsMatrix.removeAll()
            
            locationManager.stopUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            self.isGpsUpdatingForServer = false
            
        }
    }
    
    func checkDetectDrive3() -> Bool{
        let detectDriveState = DriveUtil.getDetectDriveState()
        if detectDriveState == 3 {
            print("DetectDrive 3 is detect")
            changeToDD3()
            return true
        }
        
        return false
    }
    
    func checkSleepDay()->Bool{
        if ConfigUtil().isSleepDay(){
            print("SleepDay is detect")
            return true
        }
        return false
    }
    
    func checkSleepTime() -> Bool{
        if ConfigUtil().isOnSleepTime(){
            print("SleepTime is detect")
            return true
        }
        
        return false
    }
    
    func checkGpsDaily()->Bool{
        if VariablesUtil.isMaxDailyGpsAccess() {
            // LastDD to sleepTimeEnd
            print("Máximo Gps Daily")
            return true
        }
        return false
    }
    
    func checkDD1Limit()->Bool{
        if VariablesUtil.isMaxDD1Times(){
            changeToDD3()
            print("Máximo DD1 Daily")
            return true
        }
        return false
    }
    
    func checkDD2Limit()->Bool{
        if VariablesUtil.isMaxDD2Times(){
            changeToDD3()
            print("Máximo DD2 Daily")
            return true
        }
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       if let error = error as? CLError, error.code == .denied {
          // Location updates are not authorized.
          manager.stopMonitoringSignificantLocationChanges()
          return
       }
       // Notify the user of any errors.
    }

    
    func changeToDD3(){
        let detectDriveDuration = ConfigUtil().getDetectDriveDuration()
        let dateDetectDrive = VariablesUtil.getDetectDriveDate().addingTimeInterval(TimeInterval(detectDriveDuration))
        print("dateDetectDrive: \(dateDetectDrive)")
        let dateSleepTimeStart = ConfigUtil().getSleepTimeStart()
        print("dateSleepTimeStart: \(dateSleepTimeStart)")
        if dateDetectDrive >= dateSleepTimeStart {
            print("detectDriveDate is over sleepTime")
            VariablesUtil.resetVariables()
            
        }else{
            self.lastDDDate = dateDetectDrive
            VariablesUtil.setLastDateDetection(date: self.lastDDDate)
        }
        
        
        DriveUtil.setDetectDriveState(detectDriveState: 0)
    }
}
