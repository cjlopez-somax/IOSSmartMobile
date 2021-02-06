//
//  ConfigModel.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct Config: Decodable {
    var timeInterval: Int = DefaultConfigConstantes.TIME_INTERVAL_DEFAULT
    var timeIntervalIOS: Int = 60
    var sampleRateGPS: Int = DefaultConfigConstantes.SAMPLE_RATE_GPS_DEFAULT
    var timeGPS: Int = DefaultConfigConstantes.TIME_GPS_DEFAULT
    var timeAcc: Int = DefaultConfigConstantes.TIME_ACC_DEFAULT
    var timeAccPassenger: Int = DefaultConfigConstantes.TIME_ACC_PASSENGER_DEFAULT
    var sleeptimeStart: String = DefaultConfigConstantes.SLEEP_TIME_START_DEFAULT
    var sleeptimeEnd: String = DefaultConfigConstantes.SLEEP_TIME_END_DEFAULT
    var sleepDays: String = DefaultConfigConstantes.SLEEP_DAYS_DEFAULT
    var dailyAccAccess: Int = DefaultConfigConstantes.DAILY_ACC_ACCESS_DEFAULT
    var dailyGPSAccess: Int = DefaultConfigConstantes.DAILY_GPS_ACCESS_DEFAULT
    var detectDriveDuration: Int = DefaultConfigConstantes.DETECT_DRIVE_DURATION_DEFAULT
    var configUpdatePeriod: Int = DefaultConfigConstantes.CONFIG_UPDATE_PERIOD_DEFAULT
    var passengerLimitStart: Int = DefaultConfigConstantes.PASSENGER_LIMIT_START_DEFAULT
    var passengerLimitStop: Int = DefaultConfigConstantes.PASSENGER_LIMIT_STOP_DEFAULT
    var dd1TimesLimit: Int = DefaultConfigConstantes.DD1_TIMES_LIMIT_DEFAULT
    var dd2TimesLimit: Int = DefaultConfigConstantes.DD2_TIMES_LIMIT_DEFAULT
    var phoneInvalid: Int = DefaultConfigConstantes.PHONE_INVALID_DEFAULT
    var sizeGpsIOs: Int = DefaultConfigConstantes.SIZE_GPS_IOS_DEFAULT
    
    init() {
        
    }
    
    init(timeInterval:Int, sampleRateGPS:Int, timeGPS: Int, timeAcc: Int, timeAccPassenger: Int, sleeptimeStart: String, sleeptimeEnd: String, sleepDays: String, dailyAccAccess: Int, dailyGPSAccess: Int, detectDriveDuration: Int, configUpdatePeriod: Int, passengerLimitStart: Int, passengerLimitStop:Int, dd1TimesLimit: Int, dd2TimesLimit: Int, phoneInvalid: Int, sizeGpsIOs: Int){
        self.timeInterval = timeInterval
        self.sampleRateGPS = sampleRateGPS
        self.timeGPS = timeGPS
        self.timeAcc = timeAcc
        self.timeAccPassenger = timeAccPassenger
        self.sleeptimeStart = sleeptimeStart
        self.sleeptimeEnd = sleeptimeEnd
        self.sleepDays = sleepDays
        self.dailyAccAccess = dailyAccAccess
        self.dailyGPSAccess = dailyGPSAccess
        self.detectDriveDuration = detectDriveDuration
        self.configUpdatePeriod = configUpdatePeriod
        self.passengerLimitStart = passengerLimitStart
        self.passengerLimitStop = passengerLimitStop
        self.dd1TimesLimit = dd1TimesLimit
        self.dd2TimesLimit = dd2TimesLimit
        self.phoneInvalid = phoneInvalid
        self.sizeGpsIOs = sizeGpsIOs
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timeInterval = Int( try values.decode(String.self, forKey: .timeInterval)) ?? DefaultConfigConstantes.TIME_INTERVAL_DEFAULT
        sampleRateGPS = Int( try values.decode(String.self, forKey: .sampleRateGPS)) ?? DefaultConfigConstantes.SAMPLE_RATE_GPS_DEFAULT
        timeGPS = Int( try values.decode(String.self, forKey: .timeGPS)) ?? DefaultConfigConstantes.TIME_GPS_DEFAULT
        timeAcc = Int( try values.decode(String.self, forKey: .timeAcc)) ?? DefaultConfigConstantes.TIME_ACC_DEFAULT
        timeAccPassenger = Int (try values.decode(String.self, forKey: .timeAccPassenger)) ?? DefaultConfigConstantes.TIME_ACC_PASSENGER_DEFAULT
        sleeptimeStart = try values.decode(String.self, forKey: .sleeptimeStart)
        sleeptimeEnd = try values.decode(String.self, forKey: .sleeptimeEnd)
        sleepDays = try values.decode(String.self, forKey: .sleepDays)
        dailyAccAccess = Int( try values.decode(String.self, forKey: .dailyAccAccess)) ?? DefaultConfigConstantes.DAILY_ACC_ACCESS_DEFAULT
        dailyGPSAccess = Int( try values.decode(String.self, forKey: .dailyGPSAccess)) ?? DefaultConfigConstantes.DAILY_GPS_ACCESS_DEFAULT
        detectDriveDuration = Int(try values.decode(String.self, forKey: .detectDriveDuration)) ?? DefaultConfigConstantes.DETECT_DRIVE_DURATION_DEFAULT
        configUpdatePeriod = Int(try values.decode(String.self, forKey: .configUpdatePeriod)) ?? DefaultConfigConstantes.CONFIG_UPDATE_PERIOD_DEFAULT
        passengerLimitStart = Int(try values.decode(String.self, forKey: .passengerLimitStart)) ?? DefaultConfigConstantes.PASSENGER_LIMIT_START_DEFAULT
        passengerLimitStop = Int(try values.decode(String.self, forKey: .passengerLimitStop)) ?? DefaultConfigConstantes.PASSENGER_LIMIT_STOP_DEFAULT
        dd1TimesLimit = Int(try values.decode(String.self, forKey: .dd1TimesLimit)) ?? DefaultConfigConstantes.DD1_TIMES_LIMIT_DEFAULT
        dd2TimesLimit = Int(try values.decode(String.self, forKey: .dd2TimesLimit)) ?? DefaultConfigConstantes.DD2_TIMES_LIMIT_DEFAULT
        phoneInvalid = Int(try values.decode(String.self, forKey: .phoneInvalid)) ?? DefaultConfigConstantes.PHONE_INVALID_DEFAULT
        sizeGpsIOs = Int(try values.decode(String.self, forKey: .sizeGpsIOs)) ?? DefaultConfigConstantes.SIZE_GPS_IOS_DEFAULT
        
    }
    
    enum CodingKeys: String, CodingKey {
        case timeInterval = "timeInterval"
        case timeIntervalIOS = "timeIntervalIOS"
        case sampleRateGPS = "sampleRateGPS"
        case timeGPS = "timeGPS"
        case timeAcc = "timeAcc"
        case timeAccPassenger = "timeAccPassenger"
        case sleeptimeStart = "sleeptimeStart"
        case sleeptimeEnd = "sleeptimeEnd"
        case sleepDays = "sleepDays"
        case dailyAccAccess = "dailyAccAccess"
        case dailyGPSAccess = "dailyGPSAccess"
        case detectDriveDuration = "detectDriveDuration"
        case configUpdatePeriod = "configUpdatePeriod"
        case passengerLimitStart = "passengerLimitStart"
        case passengerLimitStop = "passengerLimitStop"
        case dd1TimesLimit = "dd1TimesLimit"
        case dd2TimesLimit = "dd2TimesLimit"
        
        case phoneInvalid = "phoneInvalid"
        case sizeGpsIOs = "sizeGpsIOs"
        
        
    }
}
