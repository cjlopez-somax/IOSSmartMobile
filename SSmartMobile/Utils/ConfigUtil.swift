//
//  ConfigUtil.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

class ConfigUtil{
    init() {
    
    }
    
    func saveConfig(config:Config){
        print("saveConfig is called")
        let preferences = UserDefaults.standard
        preferences.set(config.timeInterval, forKey: Constantes.TIME_INTERVAL)
        preferences.set(config.sampleRateGPS, forKey: Constantes.SAMPLE_RATE_GPS)
        preferences.set(config.timeGPS, forKey: Constantes.TIME_GPS)
        preferences.set(config.timeAcc, forKey: Constantes.TIME_ACC)
        preferences.set(config.timeAccPassenger, forKey: Constantes.TIME_ACC_PASSENGER)
        preferences.set(config.sleeptimeStart, forKey: Constantes.SLEEP_TIME_START)
        preferences.set(config.sleeptimeEnd, forKey: Constantes.SLEEP_TIME_END)
        preferences.set(config.sleepDays, forKey: Constantes.SLEEP_DAYS)
        preferences.set(config.dailyAccAccess, forKey: Constantes.DAILY_ACC_ACCESS)
        preferences.set(config.dailyGPSAccess, forKey: Constantes.DAILY_GPS_ACCESS)
        preferences.set(config.detectDriveDuration, forKey: Constantes.DETECT_DRIVE_DURATION)
        preferences.set(config.configUpdatePeriod, forKey: Constantes.CONFIG_UPDATE_PERIOD)
        preferences.set(config.passengerLimitStart, forKey: Constantes.PASSENGER_LIMIT_START)
        preferences.set(config.passengerLimitStop, forKey: Constantes.PASSENGER_LIMIT_STOP)
        preferences.set(config.dd1TimesLimit, forKey: Constantes.DD1_TIMES_LIMIT)
        preferences.set(config.dd2TimesLimit, forKey: Constantes.DD2_TIMES_LIMIT)
        
        preferences.set(config.phoneInvalid, forKey: Constantes.PHONE_INVALID)
    }
    
    func getTimeIntervalGPS() -> Int{
        print("getTimeIntervalGps is called")
        let preferences = UserDefaults.standard
        let timeInterval = preferences.integer(forKey: Constantes.TIME_INTERVAL)
        print("timeInterval: \(timeInterval)")
        return timeInterval != 0 ? timeInterval : DefaultConfigConstantes.TIME_INTERVAL
    }
    
    func getSampleRateGps() -> Int{
        print("detSampleRateGps is called")
        let preferences = UserDefaults.standard
        let sampleRateGps = preferences.integer(forKey: Constantes.SAMPLE_RATE_GPS)
        print("sampleRateOfPreference: \(sampleRateGps)")
        return sampleRateGps != 0 ? sampleRateGps : DefaultConfigConstantes.SAMPLE_RATE_GPS_DEFAULT
    }
    
    func getTimeGps() -> Int{
        print("getTimeGps is called")
        let preferences = UserDefaults.standard
        let timeGps = preferences.integer(forKey: Constantes.TIME_GPS)
        print("timeGpsOfPreference: \(timeGps)")
        return timeGps != 0 ? timeGps : DefaultConfigConstantes.TIME_GPS_DEFAULT
    }
}
