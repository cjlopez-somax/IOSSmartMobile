//
//  GpsInfo.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct GpsInfo:Codable{
    var latitude: Double?
    var longitude: Double?
    var dateTime: String?
    
    init(latitude:Double? = nil, longitude:Double?=nil, dateTime: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.dateTime = dateTime
    }
}
