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
    
    init() {
        
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
        
        
    }
}
