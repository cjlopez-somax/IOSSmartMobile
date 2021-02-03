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
    private var dateStartLocation: Date?
    private var dateEndLocation:Date?
    
    private var lastDDDate:Date = GeneralFunctions.getCurrentTime()//VariablesUtil.getLastDateDetection()
    private var isGpsUpdatingForServer:Bool = false
    
    private let regionInMeters:Double = 500
    private var gpsMatrix = [GpsInfo] ()
    
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
            checkLocationAuthorization(manager: false)
        }else{
            print("Location Disabled")
        }
        
    }
    
    
    func initLocation(){
        print("Iniciar Location")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func checkLocationAuthorization(manager:Bool){
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
                    let alert = UIAlertController(title: "El uso de GPS es necesario para obtener su actual posición", message: "Por favor permita el acceso a GPS Siempre", preferredStyle: .alert)
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
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func getEndTimeGps(){
        let timeGps = ConfigUtil().getTimeGps()
        self.dateEndLocation = self.dateStartLocation?.addingTimeInterval(TimeInterval(timeGps))
    }
    
    
    
    func sendDataToServer(){
        let gpsData = GpsData(gpsMatrix: self.gpsMatrix, dateTimeStart: self.dateStartLocation?.getRFC3339Date(), dateTimeEnd: self.dateEndLocation?.getRFC3339Date(), lastDD: DriveUtil.getDetectDriveState())
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
    
    func checkSleepTimeStart(current:Date, gpsDataList: [GpsData])->Bool{
        let sleepTimeStart = ConfigUtil().getSleepTimeStart()
        if current >= sleepTimeStart{
            ConfigUtil().checkConfigUpdate()
            if gpsDataList.count > 0 {
                GpsSqlite.deleteTablesGps()
            }
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
    
    
    func showMessageGPSOff(){
        print("GPS Off")
        self.gpsStateLabel.isHidden = false
    }
    
    func GPSOn(){
        print("GpsOn")
        self.gpsStateLabel.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
       let location = locations.last!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("latitude: \(latitude ) - longitude: \(longitude)")
        let currentDateTime = GeneralFunctions.getCurrentTime()
        print("currentDate: \(currentDateTime)")
        let parseCurrentDate = currentDateTime.getRFC3339Date()
        print("parseCurrentDate: \(parseCurrentDate)")
        if !self.isGpsUpdatingForServer {
            
            if ConfigUtil().isPhoneInvalid(){
                locationManager.stopMonitoringSignificantLocationChanges()
                locationManager.stopUpdatingLocation()
                goToLogin()
            }
            
            let gpsDataList = GpsSqlite.getGpsData()
            
            if gpsDataList.count > 0 {
                print("Data GPS pending exist")
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
        let gpsInfo = GpsInfo(latitude: latitude, longitude: longitude, dateTime: currentDateTime.getRFC3339Date())
        self.gpsMatrix.append(gpsInfo)
        if currentDateTime >= self.dateEndLocation!{
            print("Diference is less")
            sendDataToServer()
            
            stopGps()
        }
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
        
        checkLocationAuthorization(manager:true)
    }
    
    
    
    func goToLogin(){
        
        LoginUtil().logout()
        ConfigUtil().saveConfig(config: Config())
        
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "login")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Pantalla desaparece")
    }
    
    
}
