//
//  GpsDataModel.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct GpsData:Encodable{
    var _id:String
    var platform:String="ios"
    var id: String
    var pass: String
    var dateTimeStart: String?
    var dateTimeEnd: String?
    var lastDD: Int
    var gpsMatrix = [GpsInfo] ()
    
    init(gpsMatrix: [GpsInfo], dateTimeStart: Date?=nil, dateTimeEnd: Date?=nil) {
        self.id = LoginUtil().getIdUser()
        self.pass = LoginUtil().getPassword()
        
        self.gpsMatrix = gpsMatrix
        self.dateTimeStart = dateTimeStart?.getFormattedDate()
        self.dateTimeEnd = dateTimeEnd?.getFormattedDate()
        self.lastDD = DriveUtil.getDetectDriveState()
        self._id = GeneralFunctions.getIdentifierMovil()
    }
}



