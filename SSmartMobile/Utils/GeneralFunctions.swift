//
//  GeneralFunctions.swift
//  SSmartMobile
//
//  Created by Christian on 25-01-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import Foundation
import UIKit
class GeneralFunctions: NSObject{
    class func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
    
    class func getIdentifierMovil()-> String{
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        
        return ""
    }
    
    class func getCurrentTime() -> Date{
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
        let date = Date(timeInterval: seconds, since: Date())
        return date
    }
    
    class func getDateTimeZone(date:Date)-> Date{
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: Date()))
        let date = Date(timeInterval: seconds, since: date)
        return date;
    }
    
}
