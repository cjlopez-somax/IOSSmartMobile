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
        preferences.set(config.sizeGpsIOs, forKey: Constantes.SIZE_GPS_IOS)
    }
    
    func getTimeInterval() -> Int{
        print("getTimeIntervalGps is called")
        let preferences = UserDefaults.standard
        let timeInterval = preferences.integer(forKey: Constantes.TIME_INTERVAL)
        print("timeInterval: \(timeInterval)")
        let finalTimeInterval = timeInterval != 0 ? timeInterval : DefaultConfigConstantes.TIME_INTERVAL_DEFAULT
        return finalTimeInterval * 60
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
    
    func getSleepDays()->Array<Int>{
        let preferences = UserDefaults.standard
        let sleepDays = preferences.string(forKey: Constantes.SLEEP_DAYS)
        let days = sleepDays?.components(separatedBy: ",")
        var intArraySleepDays = Array<Int>()
        for day in days! {
            intArraySleepDays.append(Int(day) ?? 0)
        }
        return intArraySleepDays
    }
    
    func isSleepDay()->Bool{
        let sleepDays = getSleepDays()
        let date = Date()
        let calendar = Calendar.current
        let actualDayGregorian = calendar.component(.weekday, from: date)
        let actualDay = actualDayGregorian == 1 ? 7 : actualDayGregorian - 1
        for day in sleepDays{
            if actualDay == day{
                return true
            }
        }
        return false
    }
    
    func getSleepTimeStart() -> Date{
        let preferences = UserDefaults.standard
        let sleepTimeStart = preferences.string(forKey: Constantes.SLEEP_TIME_START) ?? DefaultConfigConstantes.SLEEP_TIME_START_DEFAULT
        let sleepTime = sleepTimeStart.components(separatedBy: ":")
        let hour = Int((sleepTime[0]))
        let minutes = Int((sleepTime[1]))
        let date = Calendar.current.date(bySettingHour: hour!, minute: minutes!, second: 0, of: Date())!
        let finalDate = GeneralFunctions.getDateTimeZone(date:date)
        
        return finalDate
    }
    
    func getSleepTimeEnd() -> Date{
        let preferences = UserDefaults.standard
        let sleepTimeEnd = preferences.string(forKey: Constantes.SLEEP_TIME_END) ?? DefaultConfigConstantes.SLEEP_TIME_END_DEFAULT
        let sleepTime = sleepTimeEnd.components(separatedBy: ":")
        let hour = Int((sleepTime[0]))
        let minutes = Int((sleepTime[1]))
        let date = Calendar.current.date(bySettingHour: hour!, minute: minutes!, second: 0, of: Date())!
        let finalDate = GeneralFunctions.getDateTimeZone(date:date)
        return finalDate
    }
    
    func isOnSleepTime()->Bool{
        let sleepTimeStart = getSleepTimeStart()
        let sleepTimeEnd = getSleepTimeEnd()
        let actualDate = GeneralFunctions.getCurrentTime()
        print("sleepTimeStart: \(sleepTimeStart)" )
        print("sleepTimeEnd: \(sleepTimeEnd)" )
        print("actualDate: \(actualDate)" )
        
        if actualDate < sleepTimeEnd || actualDate > sleepTimeStart {
            return true
        }
        
        return false
    }
    
    func getDetectDriveDuration()->Int{
        let preferences = UserDefaults.standard
        let detectDriveDuration = preferences.integer(forKey: Constantes.DETECT_DRIVE_DURATION)
        let finalDetectDrive = detectDriveDuration != 0 ? detectDriveDuration : DefaultConfigConstantes.DETECT_DRIVE_DURATION_DEFAULT
        return finalDetectDrive * 60
    }
    
    func setLastConfigUpdateDate(date:Date){
        let preferences = UserDefaults.standard
        preferences.set(date, forKey: Constantes.LAST_CONFIG_UPDATE)
    }
    
    func getLastConfigUpdateDate() -> Date{
        let preferences = UserDefaults.standard
        var date = GeneralFunctions.getCurrentTime()
        if let dateStore = preferences.object(forKey: Constantes.LAST_CONFIG_UPDATE) as? Date {
             date = dateStore
        }
        print("date: \(date)")
        return date
    }
    
    
    func checkConfigUpdate(){
        print("checkConfigUpdate is called")
        let lastConfigUpdate = getLastConfigUpdateDate()
        let isSameDay = Calendar.current.isDate(lastConfigUpdate, inSameDayAs: GeneralFunctions.getCurrentTime())
        if !isSameDay{
            ConfigController().getConfig()
        }
    }
    
    
    func validateConfig(config:Config)->Bool{
        
        
        if config.timeInterval < 1 ||
            config.timeGPS <= 0 ||
            config.dailyGPSAccess <= 0 ||
            config.detectDriveDuration <= 0 ||
            config.dd1TimesLimit <= 0 ||
            config.dd2TimesLimit <= 0 ||
            config.sleeptimeStart.isEmpty ||
            config.sleeptimeEnd.isEmpty{
                    print("Problems on general validateConfig")
                    return false;
        }
        let sleepTimeStart = config.sleeptimeStart.components(separatedBy: ":")
        let sleepTimeEnd = config.sleeptimeEnd.components(separatedBy: ":")
        
        let sleepTimeStartHour = Int(sleepTimeStart[0]) ?? 0
        let sleepTimeStartMinutes = Int(sleepTimeStart[1]) ?? 0
        
        let sleepTimeEndHour = Int(sleepTimeEnd[0]) ?? 0
        let sleepTimeEndMinutes = Int(sleepTimeEnd[1]) ?? 0
        
        if (sleepTimeStartHour < 0 || sleepTimeStartHour > 24 || sleepTimeStartMinutes < 0 || sleepTimeStartMinutes > 60) ||
            (sleepTimeEndHour < 0 || sleepTimeEndHour > 24 || sleepTimeEndMinutes < 0 || sleepTimeEndMinutes > 60) ||
            (config.phoneInvalid != 0 && config.phoneInvalid != 1){
            return false;
        }
        
        return true
    }
    
    func isPhoneInvalid()->Bool{
        let preferences = UserDefaults.standard
        let phoneInvalid = preferences.integer(forKey: Constantes.PHONE_INVALID)
        return phoneInvalid == 1
    }
    
    func setPhoneInvalid(){
        let preferences = UserDefaults.standard
        preferences.set(1, forKey: Constantes.PHONE_INVALID)
    }
    
    
    func getSizeGpsIOs()->Int{
        let preferences = UserDefaults.standard
        let sizeGpsIOs = preferences.integer(forKey: Constantes.SIZE_GPS_IOS)
        return sizeGpsIOs != 0 ? sizeGpsIOs : DefaultConfigConstantes.SIZE_GPS_IOS_DEFAULT
        
    }
    
}


