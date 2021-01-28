//
//  DriveUtli.swift
//  SSmartMobile
//
//  Created by Christian on 27-01-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import Foundation
class DriveUtil : NSObject {
    class func getDetectDriveState() ->Int{
        print("getDetectDriveState is called")
        let preferences = UserDefaults.standard
        let detectDrive = preferences.integer(forKey: Constantes.DETECT_DRIVE)
        return detectDrive
    }
    
    class func setDetectDriveState(detectDriveState: Int){
        print("setDetectDriveState is called")
        let preferences = UserDefaults.standard
        preferences.set(detectDriveState, forKey: Constantes.DETECT_DRIVE)
    }
}
