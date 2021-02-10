//
//  GpsInfo.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct GpsInfo:Codable{
    var latitude: String?
    var longitude: String?
    var dateTime: String?
    var speed:Double?
    
    private enum CodingKeys: String, CodingKey {
            case latitude, longitude,dateTime
        }
    
    init(latitude:Double?, longitude:Double?, dateTime: String, speed:Double?) {
        self.latitude = String(latitude!)
        self.longitude = String(longitude!)
        self.dateTime = dateTime
        self.speed = speed
    }
}
