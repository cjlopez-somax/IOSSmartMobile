//
//  DBHelper.swift
//  SSmartMobile
//
//  Created by Christian on 02-02-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper{
    
    static let TABLE_GPS_DATA  = "gpsData";
    static let TABLE_GPS_INFO  = "gpsInfo";
    
    static let DATE_TIME_START  = "dateTimeStart";
    static let DATE_TIME_END  = "dateTimeEnd";
    static let ID_DATA  = "idData";
    static let ID_GPS  = "idGps";
    static let DATE_TIME  = "dateTime";
    static let X  = "x";
    static let Y  = "y";
    static let Z  = "z";
    static let LATITUDE  = "latitude";
    static let LONGITUDE  = "longitude";
    static let LAST_DD  = "lastDD";
    
    
    var db: OpaquePointer?
    var path: String = "smartMobile.sqlite"
    init() {
        self.db = createDB()
        self.createTableGpsData()
        self.createTableGpsInfo()
    }
    
    func createDB()->OpaquePointer?{
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db :OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
            print("error")
            return nil
        }else{
            print("database create at: \(path)")
            return db
        }
        
    }
    
    
    func createTableGpsData(){
        let query = "CREATE TABLE \(DBHelper.TABLE_GPS_DATA)" +
            " (id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            " \(DBHelper.DATE_TIME_START) TEXT, " +
            "\(DBHelper.DATE_TIME_END) TEXT, " +
            "\(DBHelper.LAST_DD) INTEGER " +
            ")";
        
        var createTable : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &createTable, nil) == SQLITE_OK{
            if sqlite3_step(createTable) == SQLITE_DONE{
                print("table creationData is done success")
            }else{
                print("table creationData failed")
            }
        }else{
            print("error on prepare v2Data")
        }
    }
    
    func createTableGpsInfo(){
        let query = "CREATE TABLE \(DBHelper.TABLE_GPS_INFO)" +
            " (id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            " \(DBHelper.ID_DATA) INTEGER, " +
            "\(DBHelper.DATE_TIME) TEXT, " +
            "\(DBHelper.LATITUDE) TEXT, " +
            "\(DBHelper.LONGITUDE) TEXT " +
            ")";
        
        var createTable : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &createTable, nil) == SQLITE_OK{
            if sqlite3_step(createTable) == SQLITE_DONE{
                print("table creationInfo is done success")
            }else{
                print("table creationData failed")
            }
        }else{
            print("error on prepare v2Info")
        }
    }
}
