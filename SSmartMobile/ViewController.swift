//
//  ViewController.swift
//  SSmartMobile
//
//  Created by Christian on 17-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion



class ViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    var motion = CMMotionManager()
    private var count = 0
    private var dateStartLocation: Date?
    private var dateEndLocation:Date?
    
    private var gpsMatrix = [GpsInfo] ()
    var gameTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let randomNumber = Int.random(in: 1...20)
            print("Number: \(randomNumber)")

            if randomNumber == 10 {
                timer.invalidate()
            }
        }*/
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func iniciarLocationClick(_ sender: UIButton) {
        print("Iniciar Location")
        dateStartLocation = getCurrentTime()
        getEndTimeGps()
        print("Date Start Location: \(dateStartLocation as Any)")
        print("Date End Location: \(dateEndLocation as Any)")
        
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        print("Stop Location")
        stopLocationUpdates()
    }
    
    
    @IBAction func iniciarAccelerometerClick(_ sender: UIButton) {
        //print("Iniciar Accelerometer")
        
        ConfigController().getConfig()
        /*
        motion.accelerometerUpdateInterval = 0.5
        motion.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
            print(data as Any)
            
        } */
    }
    
    
    @IBAction func stopAccelerometerClick(_ sender: UIButton) {
        print("CancelarAcc is clicked")
        print(gpsMatrix)
        //LoginUtil().logout()
        //print("Stop Accelerometer")
        //motion.stopAccelerometerUpdates()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let currentDateTime = getCurrentTime()
            
            let gpsInfo = GpsInfo(latitude: latitude, longitude: longitude, dateTime: currentDateTime)
            self.gpsMatrix.append(gpsInfo)
            print("latitude: \(latitude ) - longitude: \(longitude)")
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
    
    func stopLocationUpdates(){
        locationManager?.stopUpdatingLocation()
        self.dateStartLocation = nil
        self.dateEndLocation = nil
        self.gpsMatrix.removeAll()
    }
    
}
