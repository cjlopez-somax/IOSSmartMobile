//
//  VariablesUtil.swift
//  SSmartMobile
//
//  Created by Christian on 28-01-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import Foundation

class VariablesUtil: NSObject{
    class func setDD1Times(dd1Times:Int){
        let preferences = UserDefaults.standard
        preferences.set(dd1Times, forKey: Constantes.DD1_TIMES)
    }
    
    class func getDD1Times()-> Int{
        let preferences = UserDefaults.standard
        let dd1Times = preferences.integer(forKey: Constantes.DD1_TIMES)
        return dd1Times
    }
    
    class func addDD1Times(){
        let dd1Times = getDD1Times()
        setDD1Times(dd1Times: dd1Times + 1)
    }
    
    class func setDD2Times(dd2Times:Int){
        let preferences = UserDefaults.standard
        preferences.set(dd2Times, forKey: Constantes.DD2_TIMES)
    }
    
    class func getDD2Times()-> Int{
        let preferences = UserDefaults.standard
        let dd2Times = preferences.integer(forKey: Constantes.DD2_TIMES)
        return dd2Times
    }
    
    class func addDD2Times(){
        let dd2Times = getDD2Times()
        setDD2Times(dd2Times: dd2Times + 1)
    }
    
    
    class func setGpsAccessTimes(gpsAccessTimes:Int){
        let preferences = UserDefaults.standard
        preferences.set(gpsAccessTimes, forKey: Constantes.ACTUAL_DAILY_GPS_ACCESS)
    }
    
    class func getGpsAccessTimes()-> Int{
        let preferences = UserDefaults.standard
        let dailyGpsAccess = preferences.integer(forKey: Constantes.ACTUAL_DAILY_GPS_ACCESS)
        return dailyGpsAccess
    }
    
    class func addGpsAccessTimes(){
        let dailyGpsAccess = getGpsAccessTimes()
        setGpsAccessTimes(gpsAccessTimes: dailyGpsAccess + 1)
    }
    
    class func isMaxDailyGpsAccess() ->Bool{
        let preferences = UserDefaults.standard
        let accessGpsMax = preferences.integer(forKey: Constantes.DAILY_GPS_ACCESS)
        let actualGpsAccess = getGpsAccessTimes()
        if actualGpsAccess > accessGpsMax {
            return true
        }
        return false
    }
}
