//
//  ConfigModel.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct Config: Decodable {
    var timeIntervalIOS: Int
    var sampleRateGPS: Int
    var timeGPS: Int
    var timeAcc: Int
    var timeAccPassenger: Int
    var sleeptimeStart: String
    var sleeptimeEnd: String
    var sleepDays: String
    var dailyAccAccess: Int
    var dailyGPSAccess: Int
    var detectDriveDuration: Int
    var configUpdatePeriod: Int
    var passengerLimitStart: Int
    var passengerLimitStop: Int
    var dd1TimesLimit: Int
    var dd2TimesLimit: Int
    
    var phoneInvalid: Int
    
    enum CodingKeys: String, CodingKey {
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
