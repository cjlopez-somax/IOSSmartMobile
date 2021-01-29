//
//  ViewController.swift
//  SSmartMobile
//
//  Created by Christian on 17-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var UIButtonCall: UIButton!
    @IBOutlet weak var UIButtonEmail: UIButton!
    
    private var locationManager = CLLocationManager()
    private var dateStartLocation: Date?
    private var dateEndLocation:Date?
    
    private var lastDDDate:Date = VariablesUtil.getLastDateDetection()
    private var isGpsUpdatingForServer:Bool = false
    
    private let regionInMeters:Double = 500
    private var gpsMatrix = [GpsInfo] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()
        
        checkLocationServices()
        
    }
    
    
    @IBAction func callClick(_ sender: UIButton) {
        if let url = URL(string: "tel://+56933874630") {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func emailClick(_ sender: UIButton) {
        let email = "mesadeayuda@somax.cl"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    
    func setupBackground(){
        overrideUserInterfaceStyle = .light
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = ["#141d47".color.cgColor, "#3d1e6a".color.cgColor]
        layer.startPoint = CGPoint(x:0,y:0.5)
        layer.endPoint = CGPoint(x:1,y:0.5)
        view.layer.insertSublayer(layer, at: 0)
    }
    
    func setupButtons(){
        UIButtonCall.backgroundColor = "#E8B321".color
        UIButtonCall.layer.cornerRadius = 5
        UIButtonCall.setTitleColor("#231198".color, for: .normal)
        UIButtonCall.tintColor = UIColor.white
        UIButtonCall.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        UIButtonEmail.backgroundColor = "#E8B321".color
        UIButtonEmail.layer.cornerRadius = 5
        UIButtonEmail.setTitleColor("#231198".color, for: .normal)
        UIButtonEmail.tintColor = UIColor.white
        UIButtonEmail.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
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
    
    
    func initLocation(){
        print("Iniciar Location")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func checkLocationAuthorization(){
        print("Code status: \(CLLocationManager.authorizationStatus())")
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,
             .authorizedWhenInUse:
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
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            print("Device does not support service for SignificantChangeMonitoring")
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
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
        let currentDateTime = GeneralFunctions.getCurrentTime()
        
        if !self.isGpsUpdatingForServer {
            
            if checkSleepDay() ||
                checkSleepTimeStart(current: currentDateTime) ||
                checkSleepTimeEnd(current: currentDateTime) ||
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
                startGps(currentDateTime:currentDateTime)
            }
            return
        }
        
        print("recolectando datos")
        let gpsInfo = GpsInfo(latitude: latitude, longitude: longitude, dateTime: currentDateTime)
        self.gpsMatrix.append(gpsInfo)
        if currentDateTime >= self.dateEndLocation!{
            print("Diference is less")
            sendDataToServer()
            stopGps()
        }
    }
    
    func sendDataToServer(){
        let gpsData = GpsData(gpsMatrix: self.gpsMatrix, dateTimeStart: self.dateStartLocation, dateTimeEnd: self.dateEndLocation)
        
        GpsController().post(gpsData: gpsData)
        self.gpsMatrix.removeAll()
    }
    
    func startGps(currentDateTime:Date){
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
        VariablesUtil.addGpsAccessTimes()
        
        let timeInterval = ConfigUtil().getTimeInterval()
        print("timeInterval: \(timeInterval)")
        self.lastDDDate = currentDateTime.addingTimeInterval(TimeInterval(timeInterval))
        VariablesUtil.setLastDateDetection(date:self.lastDDDate)
        self.dateStartLocation = GeneralFunctions.getCurrentTime()
        getEndTimeGps()
        
        self.isGpsUpdatingForServer = true
    }
    
    func stopGps(){
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        self.isGpsUpdatingForServer = false
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
    
    func checkSleepTimeEnd(current:Date)->Bool{
        let sleeptTimeEnd = ConfigUtil().getSleepTimeEnd()
        if(current < sleeptTimeEnd){
            return true
        }
        return false
    }
    
    func checkSleepTimeStart(current:Date)->Bool{
        let sleepTimeStart = ConfigUtil().getSleepTimeStart()
        if current >= sleepTimeStart{
            ConfigUtil().checkConfigUpdate()
            return true
        }
        return false
    }
    
    func checkGpsDaily()->Bool{
        if VariablesUtil.isMaxDailyGpsAccess() {
            self.lastDDDate = ConfigUtil().getSleepTimeStart()
            VariablesUtil.setLastDateDetection(date: self.lastDDDate)
            
            VariablesUtil.resetVariables()
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
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
