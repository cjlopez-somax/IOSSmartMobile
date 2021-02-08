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
    var sampleRateGPS: Int = DefaultConfigConstantes.SAMPLE_RATE_GPS_DEFAULT
    var timeGPS: Int = DefaultConfigConstantes.TIME_GPS_DEFAULT
    var sleeptimeStart: String = DefaultConfigConstantes.SLEEP_TIME_START_DEFAULT
    var sleeptimeEnd: String = DefaultConfigConstantes.SLEEP_TIME_END_DEFAULT
    var sleepDays: String = DefaultConfigConstantes.SLEEP_DAYS_DEFAULT
    var dailyGPSAccess: Int = DefaultConfigConstantes.DAILY_GPS_ACCESS_DEFAULT
    var detectDriveDuration: Int = DefaultConfigConstantes.DETECT_DRIVE_DURATION_DEFAULT
    var dd1TimesLimit: Int = DefaultConfigConstantes.DD1_TIMES_LIMIT_DEFAULT
    var dd2TimesLimit: Int = DefaultConfigConstantes.DD2_TIMES_LIMIT_DEFAULT
    var phoneInvalid: Int = DefaultConfigConstantes.PHONE_INVALID_DEFAULT
    var sizeGpsIOs: Int = DefaultConfigConstantes.SIZE_GPS_IOS_DEFAULT
    
    var minTimeBetweenLocationsIOs: Int = DefaultConfigConstantes.MIN_TIME_BETWEEN_LOCATIONS_IOS
    
    init() {
        
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let timeIntervaltemp = try? values.decode(Int.self, forKey: .timeInterval) {
            timeInterval = timeIntervaltemp
        }else{
            timeInterval = Int( try values.decode(String.self, forKey: .timeInterval)) ?? DefaultConfigConstantes.TIME_INTERVAL_DEFAULT
        }
        
        if let sampleRateGPSTemp = try? values.decode(Int.self, forKey: .sampleRateGPS) {
            sampleRateGPS = sampleRateGPSTemp
        }else{
            sampleRateGPS = Int( try values.decode(String.self, forKey: .sampleRateGPS)) ?? DefaultConfigConstantes.SAMPLE_RATE_GPS_DEFAULT

        }
        
        if let timeGPSTemp = try? values.decode(Int.self, forKey: .timeGPS) {
            timeGPS = timeGPSTemp
        }else{
            timeGPS = Int( try values.decode(String.self, forKey: .timeGPS)) ?? DefaultConfigConstantes.TIME_GPS_DEFAULT

        }
        
        
        sleeptimeStart = try values.decode(String.self, forKey: .sleeptimeStart)
        sleeptimeEnd = try values.decode(String.self, forKey: .sleeptimeEnd)
        sleepDays = try values.decode(String.self, forKey: .sleepDays)
        
        
        if let dailyGPSAccessTemp = try? values.decode(Int.self, forKey: .dailyGPSAccess) {
            dailyGPSAccess = dailyGPSAccessTemp
        }else{
            dailyGPSAccess = Int( try values.decode(String.self, forKey: .dailyGPSAccess)) ?? DefaultConfigConstantes.DAILY_GPS_ACCESS_DEFAULT


        }
        
        if let detectDriveDurationTemp = try? values.decode(Int.self, forKey: .detectDriveDuration) {
            detectDriveDuration = detectDriveDurationTemp
        }else{
            detectDriveDuration = Int(try values.decode(String.self, forKey: .detectDriveDuration)) ?? DefaultConfigConstantes.DETECT_DRIVE_DURATION_DEFAULT

        }
        
        if let dd1TimesLimitTemp = try? values.decode(Int.self, forKey: .dd1TimesLimit) {
            dd1TimesLimit = dd1TimesLimitTemp
        }else{
            dd1TimesLimit = Int(try values.decode(String.self, forKey: .dd1TimesLimit)) ?? DefaultConfigConstantes.DD1_TIMES_LIMIT_DEFAULT


        }
        
        if let dd2TimesLimitTemp = try? values.decode(Int.self, forKey: .dd2TimesLimit) {
            dd2TimesLimit = dd2TimesLimitTemp
        }else{
            dd2TimesLimit = Int(try values.decode(String.self, forKey: .dd2TimesLimit)) ?? DefaultConfigConstantes.DD2_TIMES_LIMIT_DEFAULT


        }
        
        if let phoneInvalidTemp = try? values.decode(Int.self, forKey: .phoneInvalid) {
            phoneInvalid = phoneInvalidTemp
        }else{
            phoneInvalid = Int(try values.decode(String.self, forKey: .phoneInvalid)) ?? DefaultConfigConstantes.PHONE_INVALID_DEFAULT
        }
        
        if let sizeGpsIOsTemp = try? values.decode(Int.self, forKey: .sizeGpsIOs) {
            sizeGpsIOs = sizeGpsIOsTemp
        }else{
            sizeGpsIOs = Int(try values.decode(String.self, forKey: .sizeGpsIOs)) ?? DefaultConfigConstantes.SIZE_GPS_IOS_DEFAULT
        }
        
        if let minTimeBetweenLocationsIOsTemp = try? values.decodeIfPresent(Int.self, forKey: .minTimeBetweenLocationsIOs) {
            minTimeBetweenLocationsIOs = minTimeBetweenLocationsIOsTemp
        }else{
            minTimeBetweenLocationsIOs = Int(try (values.decodeIfPresent(String.self, forKey: .minTimeBetweenLocationsIOs) ?? String(DefaultConfigConstantes.MIN_TIME_BETWEEN_LOCATIONS_IOS))) ?? DefaultConfigConstantes.MIN_TIME_BETWEEN_LOCATIONS_IOS
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case timeInterval = "timeInterval"
        case sampleRateGPS = "sampleRateGPS"
        case timeGPS = "timeGPS"
        case sleeptimeStart = "sleeptimeStart"
        case sleeptimeEnd = "sleeptimeEnd"
        case sleepDays = "sleepDays"
        case dailyGPSAccess = "dailyGPSAccess"
        case detectDriveDuration = "detectDriveDuration"
        case dd1TimesLimit = "dd1TimesLimit"
        case dd2TimesLimit = "dd2TimesLimit"
        
        case phoneInvalid = "phoneInvalid"
        case sizeGpsIOs = "sizeGpsIOs"
        case minTimeBetweenLocationsIOs = "minTimeBetweenLocationsIOs"
        
        
    }
    
}
