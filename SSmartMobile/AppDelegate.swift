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
/*
    var locationManagerDelegate = CLLocationManager()
    private var dateStartLocation: Date?
    private var dateEndLocation:Date?
    var lastDDDate:Date = GeneralFunctions.getCurrentTime()//VariablesUtil.getLastDateDetection()
    var isGpsUpdatingForServer:Bool = false
    var gpsMatrix = [GpsInfo] ()
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        /*if(launchOptions?[UIApplication.LaunchOptionsKey.location] != nil) {
            print("Significant is called to relaunch app")
            if LoginUtil().isLogin(){
                lastDDDate = GeneralFunctions.getCurrentTime() //VariablesUtil.getLastDateDetection()
                locationManagerDelegate.desiredAccuracy = kCLLocationAccuracyBest
                locationManagerDelegate.requestAlwaysAuthorization()
                locationManagerDelegate.delegate = self
                locationManagerDelegate.allowsBackgroundLocationUpdates = true
            }else{
                locationManagerDelegate.stopUpdatingLocation()
                locationManagerDelegate.stopMonitoringSignificantLocationChanges()
            }
            // handle new location that was sent, but don't launch the rest of the application

        } else {
            print("Launch app not for locationSignificant")
            // do all the regular stuff, such as setting keyWindow etc

        }*/
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will killed")
        if LoginUtil().isLogin() {
            //locationManagerDelegate.stopUpdatingLocation()
            //locationManagerDelegate.startMonitoringSignificantLocationChanges()
        }
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
    
    /*
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
       let location = locations.last!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("latitude: \(latitude ) - longitude: \(longitude)")
        let currentDateTime = GeneralFunctions.getCurrentTime()
        print("currentDate: \(currentDateTime)")
        
        if !isGpsUpdatingForServer {
            
            if ConfigUtil().isPhoneInvalid(){
                locationManagerDelegate.stopMonitoringSignificantLocationChanges()
                locationManagerDelegate.stopUpdatingLocation()
                //Logout
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
        if currentDateTime >= dateEndLocation!{
            print("Diference is less")
            sendDataToServer()
            
            stopGps()
        }
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
        locationManagerDelegate.stopMonitoringSignificantLocationChanges()
        locationManagerDelegate.startUpdatingLocation()
        
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
        locationManagerDelegate.stopUpdatingLocation()
        locationManagerDelegate.startMonitoringSignificantLocationChanges()
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
            lastDDDate = ConfigUtil().getSleepTimeStart()
            VariablesUtil.setLastDateDetection(date: lastDDDate)
            
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
            lastDDDate = dateDetectDrive
            VariablesUtil.setLastDateDetection(date: lastDDDate)
        }
        
        
        DriveUtil.setDetectDriveState(detectDriveState: 0)
    }

     */
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

