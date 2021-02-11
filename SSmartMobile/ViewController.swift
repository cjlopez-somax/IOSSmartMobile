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
    @IBOutlet weak var gpsStateLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    
    private var gpsMatrix = [GpsInfo] ()
    
    private var dateStartLocation:Date?
    
    private var lastDDDate:Date = VariablesUtil.getLastDateDetection()
    
    private var lastLocation:CLLocation?
    
    //private let minLimitSpeed = 1.38
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()
        setupLabelGps()
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
    
    func setupLabelGps(){
        gpsStateLabel.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        gpsStateLabel.addGestureRecognizer(guestureRecognizer)
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
    
    @objc func labelClicked(_ sender: Any) {
            print("UILabel clicked")
        DispatchQueue.main.async {
            // show Alert turn on gps
            let alert = UIAlertController(title: "GPS está apagado", message: "Para encender GPS ir a \n Settings/Privacy/Location Services \ny mueva el switch a ON", preferredStyle: .alert)


            let cancelAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)

            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)
        }
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
        initLocation()
        if CLLocationManager.locationServicesEnabled(){
            print("after init location")
            //checkLocationAuthorization(manager: false)
            checkAuthFirstTime()
        }else{
            print("Location Disabled")
            showMessageGPSOff()
        }
        
    }
    
    
    func initLocation(){
        print("Iniciar Location")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func checkAuthFirstTime(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            startMySignificantLocationChanges()
            break
        case .authorizedWhenInUse:
            startMySignificantLocationChanges()
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "El uso de GPS en modo 'Siempre' es necesario para el correcto funcionamiento de SmartMobile", message: "Por favor permita el acceso a GPS Siempre", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {action in

                            // open the app permission in Settings app
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                })

                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

                alert.addAction(settingsAction)
                alert.addAction(cancelAction)
                      
                alert.preferredAction = settingsAction

                self.present(alert, animated: true, completion: nil)
            }
            
            
            
            break;
        case .denied:
            print("denied access")
            if  CLLocationManager.locationServicesEnabled(){
                locationManager.requestAlwaysAuthorization()
            }
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
        
        if !CLLocationManager.locationServicesEnabled(){
            showMessageGPSOff()
        }else{
            GPSOn()
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways,
             .authorizedWhenInUse:
            startMySignificantLocationChanges()
            break
        case .denied:
            print("denied access")
            if  CLLocationManager.locationServicesEnabled(){
                print("entra a condicion")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "El uso de GPS en modo 'Siempre' es necesario para el correcto funcionamiento de SmartMobile", message: "Por favor permita el acceso a GPS Siempre", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {action in

                                // open the app permission in Settings app
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })

                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

                    alert.addAction(settingsAction)
                    alert.addAction(cancelAction)
                          
                    alert.preferredAction = settingsAction

                    self.present(alert, animated: true, completion: nil)
                }
            }
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
        
        if !CLLocationManager.locationServicesEnabled(){
            showMessageGPSOff()
        }else{
            GPSOn()
        }
    }
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            print("Device does not support service for SignificantChangeMonitoring")
            textLog.write("Device does not support service for SignificantChangeMonitoring")
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    func sendDataToServer(){
        let dataTimeStart = gpsMatrix.first?.dateTime
        let gpsData = GpsData(gpsMatrix: self.gpsMatrix, dateTimeStart: dataTimeStart, dateTimeEnd: GeneralFunctions.getCurrentTime().getRFC3339Date(), lastDD: DriveUtil.getDetectDriveState())
        GpsController().post(gpsData: gpsData)
        //resetVariablesLocations()
    }
    

    
    func checkDetectDrive3() -> Bool{
        let detectDriveState = DriveUtil.getDetectDriveState()
        if detectDriveState == 3 {
            print("DetectDrive 3 is detect")
            textLog.write("DetectDrive 3 is detect")
            changeToDD3()
            return true
        }
        
        return false
    }
    
    func checkSleepDay()->Bool{
        if ConfigUtil.isSleepDay(){
            print("SleepDay is detect")
            textLog.write("SleepDay is detect")
            return true
        }
        return false
    }
    
    func checkSleepTimeEnd(current:Date)->Bool{
        let sleeptTimeEnd = ConfigUtil.getSleepTimeEnd()
        if(current < sleeptTimeEnd){
            return true
        }
        return false
    }
    
    func checkSleepTimeStart(current:Date, gpsDataList: [GpsData])->Bool{
        let sleepTimeStart = ConfigUtil.getSleepTimeStart()
        if current >= sleepTimeStart{
            ConfigUtil.checkConfigUpdate()
            if gpsDataList.count > 0 {
                GpsSqlite.deleteTablesGps()
            }
            return true
        }
        return false
    }
    
    func checkGpsDaily()->Bool{
        if VariablesUtil.isMaxDailyGpsAccess() {
            self.lastDDDate = ConfigUtil.getSleepTimeStart()
            VariablesUtil.setLastDateDetection(date: self.lastDDDate)
            
            VariablesUtil.resetVariables()
            print("Máximo Gps Daily")
            textLog.write("Máximo Gps Daily")
            return true
        }
        return false
    }
    
    func checkDD1Limit()->Bool{
        if VariablesUtil.isMaxDD1Times(){
            changeToDD3()
            print("Máximo DD1 Daily")
            textLog.write("Máximo DD1 Daily")
            return true
        }
        return false
    }
    
    func checkDD2Limit()->Bool{
        if VariablesUtil.isMaxDD2Times(){
            changeToDD3()
            print("Máximo DD2 Daily")
            textLog.write("Máximo DD2 Daily")
            return true
        }
        return false
    }
    
    

    
    func changeToDD3(){
        textLog.write("changeToDD3 is called")
        let detectDriveDuration = ConfigUtil.getDetectDriveDuration()
        let detectDriveDateSaved = VariablesUtil.getDetectDriveDate()
        print("detectDriveDateSaved: \(detectDriveDateSaved)")
        let dateDetectDrive = detectDriveDateSaved.addingTimeInterval(TimeInterval(detectDriveDuration))
        print("dateDetectDrive: \(dateDetectDrive)")
        textLog.write("dateDetectDrive: \(dateDetectDrive)")
        let dateSleepTimeStart = ConfigUtil.getSleepTimeStart()
        print("dateSleepTimeStart: \(dateSleepTimeStart)")
        if dateDetectDrive >= dateSleepTimeStart {
            print("detectDriveDate is over sleepTime")
            VariablesUtil.resetVariables()
            self.lastDDDate = ConfigUtil.getSleepTimeStart()
        }else{
            self.lastDDDate = dateDetectDrive
            DriveUtil.setDetectDriveState(detectDriveState: 0)
        }
        VariablesUtil.setLastDateDetection(date: self.lastDDDate)
        VariablesUtil.clearDetectDriveDate()
        textLog.write("nextCollectingGpsDate: \(self.lastDDDate)")
    }
    
    
    func showMessageGPSOff(){
        print("GPS Off")
        self.gpsStateLabel.isHidden = false
    }
    
    func GPSOn(){
        print("GpsOn")
        self.gpsStateLabel.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        print("Locations count: \(locations.count) ")
        textLog.write("Locations count: \(locations.count) ")
        let location = locations.last!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("latitude: \(latitude ) - longitude: \(longitude)")
        textLog.write("latitude: \(latitude ) - longitude: \(longitude)")
        let currentDateTime = GeneralFunctions.getCurrentTime()
        print("currentDate: \(currentDateTime)")
        textLog.write("currentDate: \(currentDateTime)")
        print("lastDDDate: \(self.lastDDDate)")
        textLog.write("lastDDDate: \(self.lastDDDate)")
        if ConfigUtil.isPhoneInvalid(){
            textLog.write("phone is invalid")
            locationManager.stopMonitoringSignificantLocationChanges()
            goToLogin()
        }
        
        let gpsDataList = GpsSqlite.getGpsData()
        
        if gpsDataList.count > 0 {
            print("Data GPS pending exist")
            textLog.write("Data GPS pending exist")
            GpsController().postGpsPending(gpsDataList: gpsDataList)
        }else{
            print("No data pending")
        }
        
        if checkSleepDay() ||
            checkSleepTimeStart(current: currentDateTime, gpsDataList: gpsDataList) ||
            checkSleepTimeEnd(current: currentDateTime) ||
            checkDetectDrive3() ||
            checkGpsDaily() ||
            checkDD1Limit() ||
            checkDD2Limit(){
            print("return on check")
            textLog.write("Return on checking")
            return
        }
        
        if currentDateTime < lastDDDate {
            return;
        }
        
        if currentDateTime >= lastDDDate{
            
            var gpsInfo = GpsInfo(latitude: latitude, longitude: longitude, dateTime: currentDateTime.getRFC3339Date(), speed: 0)
            
            if lastLocation != nil{
                let difference = location.timestamp.getDateTimeZone().timeIntervalSince(lastLocation!.timestamp.getDateTimeZone())
                print("difference between points: \(difference) seconds")
                textLog.write("difference between points: \(difference) seconds")
                let distanceBetweenLocations = lastLocation?.distance(from: location).magnitude
                print("Distance between points: \(String(describing: distanceBetweenLocations)) meters")
                textLog.write("Distance between points: \(String(describing: distanceBetweenLocations)) meters")
                let speed = distanceBetweenLocations! / difference
                print("Speed between locations: \(speed) m/s")
                textLog.write("Speed between locations: \(speed) m/s")
                
                let minLimitSpeed = ConfigUtil.getMinLimitSpeedIOs()
                print("minLimitSpeedConfig: \(minLimitSpeed) m/s")
                textLog.write("minLimitSpeedConfig: \(minLimitSpeed) m/s")
                if difference >= 900{
                    resetVariablesLocations()
                    
                }else{
                    if speed <= minLimitSpeed{
                        let lastSpeed = (gpsMatrix.last?.speed) ?? 0
                        if lastSpeed == 0 || lastSpeed > minLimitSpeed{
                            gpsInfo.speed = speed
                        }else{
                            let meanSpeedMatrix = getMeanSpeedMatrix()
                            if meanSpeedMatrix == 0 || meanSpeedMatrix > minLimitSpeed{
                                gpsInfo.speed = speed
                            }else{
                                resetVariablesLocations()
                            }
                        }
                        
                    }else{
                        gpsInfo.speed = speed
                        
                    }
                    
                }
                
            }
            self.gpsMatrix.append(gpsInfo)
            print("size gpsMatrix: \(gpsMatrix.count)")
            textLog.write("size gpsMatrix: \(gpsMatrix.count)")
            lastLocation = location
            print("Dato verificado")
            textLog.write("Dato verificado")
            
            checkGpsMatrixForUpload()
            
        }
        
    }
    
    func getMeanSpeedMatrix()->Double{
        var sumSpeed:Double = 0
        for gpsInfo in self.gpsMatrix{
            sumSpeed += gpsInfo.speed!
        }
        
        return sumSpeed / Double((gpsMatrix.count - 1))
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       if let error = error as? CLError, error.code == .denied {
        print("error")
          // Location updates are not authorized.
          manager.stopMonitoringSignificantLocationChanges()
        if !CLLocationManager.locationServicesEnabled(){
            showMessageGPSOff()
        }else{
            manager.requestAlwaysAuthorization()
        }
          return
       }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("checkStatus")
        
        checkLocationAuthorization()
    }
    
    
    
    func goToLogin(){
        
        LoginUtil.logout()
        ConfigUtil.saveConfig(config: Config())
        locationManager.stopMonitoringSignificantLocationChanges()
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "login")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func checkGpsMatrixForUpload(){
        let sizeGpsIOs = ConfigUtil.getSizeGpsIOs()
        print("sizeGpsIOs: \(sizeGpsIOs)")
        if gpsMatrix.count >= sizeGpsIOs {
            sendDataToServer()
            //let timeInterval = ConfigUtil().getTimeInterval()
            //self.lastDDDate = GeneralFunctions.getCurrentTime().addingTimeInterval(TimeInterval(timeInterval))
            //VariablesUtil.setLastDateDetection(date:self.lastDDDate)
            resetVariablesLocations()
        }
        
    }
    
    func resetVariablesLocations(){
        print("reset gpsMatrix and lastLocation")
        textLog.write("reset gpsMatrix and lastLocation")
        lastLocation = nil
        self.gpsMatrix.removeAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("SmartMobile didDisappear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("SmartMobile will Disappear")
    }
    
    
}

