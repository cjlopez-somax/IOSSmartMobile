//
//  GpsDataModel.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct GpsData:Encodable{
    var platform:String="ios"
    var idUser: String
    var password: String
    var dateTimeStart: String?
    var dateTimeEnd: String?
    var lastDD: Int
    var gpsMatrix = [GpsInfo] ()
    
    init(gpsMatrix: [GpsInfo], dateTimeStart: Date?=nil, dateTimeEnd: Date?=nil) {
        self.idUser = LoginUtil().getIdUser()
        self.password = LoginUtil().getPassword()
        
        self.gpsMatrix = gpsMatrix
        self.dateTimeStart = dateTimeStart?.getFormattedDate()
        self.dateTimeEnd = dateTimeEnd?.getFormattedDate()
        self.lastDD = 0
    }
}



