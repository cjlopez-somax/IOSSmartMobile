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
    
    var gameTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let randomNumber = Int.random(in: 1...20)
            print("Number: \(randomNumber)")

            if randomNumber == 10 {
                timer.invalidate()
            }
        }
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func iniciarLocationClick(_ sender: UIButton) {
        print("Iniciar Location")
        dateStartLocation = getCurrentTime()
        dateEndLocation = dateStartLocation?.addingTimeInterval(30)
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
        locationManager?.stopUpdatingLocation()
    }
    
    
    @IBAction func iniciarAccelerometerClick(_ sender: UIButton) {
        //print("Iniciar Accelerometer")
        
        let isLogin = LoginUtil().isLogin()
        print("isLogin : \(isLogin)")
        /*
        motion.accelerometerUpdateInterval = 0.5
        motion.startAccelerometerUpdates(to: OperationQueue.current!){ (data, error) in
            print(data as Any)
            
        } */
    }
    
    
    @IBAction func stopAccelerometerClick(_ sender: UIButton) {
        LoginUtil().logout()
        //print("Stop Accelerometer")
        //motion.stopAccelerometerUpdates()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.count += 1
            print("latitude: \(latitude ) - longitude: \(longitude)")
            let currentDateTime = getCurrentTime()
            let diffComponents = Calendar.current.dateComponents([.second], from: currentDateTime, to: dateEndLocation!)
            let seconds = diffComponents.second
            print("Count: \(self.count)")
            print("Difference in seconds: \(String(describing: seconds))")
            if seconds ?? 0 <= 0 {
                print("Diference is less")
            }
            
        }
    }
    
    func getCurrentTime() -> Date{
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
        let date = Date(timeInterval: seconds, since: Date())
        return date
    }
    
    
}

