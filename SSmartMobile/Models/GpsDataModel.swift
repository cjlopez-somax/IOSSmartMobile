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
    var idData:Int = -1
    var id: String
    var pass: String
    var dateTimeStart: String?
    var datetimeEnd: String?
    var lastDD: Int
    var gpsMatrix = [GpsInfo] ()
    
    init(gpsMatrix: [GpsInfo], dateTimeStart: String?, dateTimeEnd: String?, lastDD:Int) {
        self.id = LoginUtil().getIdUser()
        self.pass = LoginUtil().getPassword()
        
        self.gpsMatrix = gpsMatrix
        self.dateTimeStart = dateTimeStart
        self.datetimeEnd = dateTimeEnd
        self.lastDD = lastDD
        self._id = GeneralFunctions.getIdentifierMovil()
    }
    
    init(gpsMatrix: [GpsInfo], dateTimeStart: String?, dateTimeEnd: String?, lastDD:Int, idData:Int) {
        self.id = LoginUtil().getIdUser()
        self.pass = LoginUtil().getPassword()
        
        self.gpsMatrix = gpsMatrix
        self.dateTimeStart = dateTimeStart
        self.datetimeEnd = dateTimeEnd
        self.lastDD = lastDD
        self._id = GeneralFunctions.getIdentifierMovil()
        self.idData = idData
    }
}



