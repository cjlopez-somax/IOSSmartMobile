//
//  GpsSqlite.swift
//  SSmartMobile
//
//  Created by Christian on 02-02-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import Foundation
import SQLite3

class GpsSqlite: NSObject {
    static let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    class func insertGpsData(gpsData:GpsData){
        
        let dbQueue = DBHelper().db
        
        let insertStatement = "INSERT INTO \(DBHelper.TABLE_GPS_DATA) ( \(DBHelper.DATE_TIME_START), \(DBHelper.DATE_TIME_END), \(DBHelper.LAST_DD) ) VALUES (?,?,?);"
        
        var insertStatementQuery: OpaquePointer?
        
        if sqlite3_prepare_v2(dbQueue, insertStatement, -1, &insertStatementQuery, nil) == SQLITE_OK{
            
            sqlite3_bind_text(insertStatementQuery, 1, gpsData.dateTimeStart, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatementQuery, 2, gpsData.datetimeEnd, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(insertStatementQuery, 3, Int32(gpsData.lastDD))
            
            if sqlite3_step(insertStatementQuery) == SQLITE_DONE{
                sqlite3_finalize(insertStatementQuery)
                
                let queryMaxID = "SELECT MAX(id) FROM \(DBHelper.TABLE_GPS_DATA)"
                var maxIDStatementQuery: OpaquePointer?
                var id = -1
                if sqlite3_prepare_v2(dbQueue, queryMaxID, -1, &maxIDStatementQuery, nil) == SQLITE_OK{
                    if sqlite3_step(maxIDStatementQuery) == SQLITE_ROW{
                        id = Int(sqlite3_column_int(maxIDStatementQuery, 0))
                        print("ID INSERTADO: \(id)" )
                    }
                }
                sqlite3_finalize(maxIDStatementQuery)
                if id != -1 {
                    print("entra a id distinto de 1")
                    print("Size of matrixInfo: \(gpsData.gpsMatrix.count)")
                    for gpsInfo in gpsData.gpsMatrix{
                        var insertInfoQuery: OpaquePointer?
                        let insertStatementInfo = "INSERT INTO \(DBHelper.TABLE_GPS_INFO) ( \(DBHelper.ID_DATA), \(DBHelper.DATE_TIME), \(DBHelper.LATITUDE), \(DBHelper.LONGITUDE) ) VALUES (?,?,?,?);"
                        if sqlite3_prepare_v2(dbQueue, insertStatementInfo, -1, &insertInfoQuery, nil) == SQLITE_OK{
                            sqlite3_bind_int(insertInfoQuery, 1, Int32(id))
                            sqlite3_bind_text(insertInfoQuery, 2, gpsInfo.dateTime, -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insertInfoQuery, 3, String(gpsInfo.latitude!), -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insertInfoQuery, 4, String(gpsInfo.longitude!), -1, SQLITE_TRANSIENT)
                            
                            if sqlite3_step(insertInfoQuery) == SQLITE_DONE{
                                print("Info save on bd")
                            }
                            sqlite3_finalize(insertInfoQuery)
                            
                        }else{
                            print("Error on insert Info")
                        }
                    }
                    
                }
                
                
                
            }else{
                print("Error on insert GpsData")
            }
            
            
            sqlite3_close(dbQueue)
        }
        
    }
    
    class func getGpsData()->[GpsData]{
        let dbQueue = DBHelper().db
        let getStatement = "SELECT * FROM \(DBHelper.TABLE_GPS_DATA)"
        var getStatementQuery: OpaquePointer?
        
        var gpsDataList = [GpsData] ()
        if sqlite3_prepare_v2(dbQueue, getStatement, -1, &getStatementQuery, nil) == SQLITE_OK{

            while sqlite3_step(getStatementQuery) == SQLITE_ROW{
                let id = sqlite3_column_int(getStatementQuery, 0)
                let dateTimeStart =  String(cString: sqlite3_column_text(getStatementQuery, 1))
                let dateTimeEnd = String(cString: sqlite3_column_text(getStatementQuery, 2))
                let lastDD = sqlite3_column_int(getStatementQuery, 3)
                
                print("\(id).- dateTimeStart: \(dateTimeStart) - dateTimeEnd: \(dateTimeEnd) - LastDD: \(lastDD)")
                let gpsMatrix = getGpsMatrixInfo(db: dbQueue, id: Int(id))
                let gpsData = GpsData(gpsMatrix: gpsMatrix, dateTimeStart: dateTimeStart, dateTimeEnd: dateTimeEnd, lastDD: Int(lastDD), idData: Int(id))
                gpsDataList.append(gpsData)
            }
        }
        
        sqlite3_finalize(getStatementQuery)
        sqlite3_close(dbQueue)
        
        return gpsDataList
        
    }
    
    class func getGpsMatrixInfo(db:OpaquePointer?,id:Int) ->[GpsInfo]{
        let getStatementInfo = "SELECT * FROM \(DBHelper.TABLE_GPS_INFO) WHERE \(DBHelper.ID_DATA) = \(id)"
        var getStatementQueryInfo: OpaquePointer?
        var gpsMatrix = [GpsInfo] ()
        if sqlite3_prepare_v2(db, getStatementInfo, -1, &getStatementQueryInfo, nil) == SQLITE_OK{
            while sqlite3_step(getStatementQueryInfo) == SQLITE_ROW{
                let dateTime =  String(cString: sqlite3_column_text(getStatementQueryInfo, 2))
                let latitude =  String(cString: sqlite3_column_text(getStatementQueryInfo, 3))
                let longitude = String(cString: sqlite3_column_text(getStatementQueryInfo, 4))
                
                let gpsInfo = GpsInfo(latitude: Double(latitude), longitude: Double(longitude), dateTime: dateTime, speed:0)
                gpsMatrix.append(gpsInfo)
                
                // Buscar gpsInfoCon ID GPASDATA
            }
        }
        sqlite3_finalize(getStatementQueryInfo)
        return gpsMatrix
    }
    
    class func deleteGpsPendingSaved(gpsDataList:[GpsData]){
        let dbQueue = DBHelper().db
        
        
        for gpsData in gpsDataList {
            let deleteStatementString = "DELETE FROM \(DBHelper.TABLE_GPS_DATA) WHERE id = ?"
            var deleteStatementData: OpaquePointer?
            if sqlite3_prepare_v2(dbQueue, deleteStatementString, -1, &deleteStatementData, nil) == SQLITE_OK {
                sqlite3_bind_int(deleteStatementData, 1, Int32(gpsData.idData))
                if sqlite3_step(deleteStatementData) == SQLITE_DONE {
                    print("Successfully deleted Data row.")
                
                    let deleteStatementStringInfo = "DELETE FROM \(DBHelper.TABLE_GPS_INFO) WHERE \(DBHelper.ID_DATA) = ?"
                    var deleteStatementInfo: OpaquePointer?
                    if sqlite3_prepare_v2(dbQueue, deleteStatementStringInfo, -1, &deleteStatementInfo, nil) == SQLITE_OK {
                        sqlite3_bind_int(deleteStatementInfo, 1, Int32(gpsData.idData))
                        if sqlite3_step(deleteStatementInfo) == SQLITE_DONE {
                            print("Info delete Ok")
                        }else{
                            print("Info delete Fail")
                        }
                    }else{
                        print("Delete Info prepare fail")
                    }
                    
                    sqlite3_finalize(deleteStatementInfo)
                    
                } else {
                    print("Could not delete Data row.")
                }
            }else{
                print("Data prepare fail")
            }
            
            sqlite3_finalize(deleteStatementData)
            
        }
        
        sqlite3_close(dbQueue)
    }
    
    class func countGpsInfo()->Int{
        let dbQueue = DBHelper().db
        let string = "SELECT COUNT(*) FROM \(DBHelper.TABLE_GPS_INFO);"
        var insertStatementCount: OpaquePointer?
        var count = 0
        if sqlite3_prepare_v2(dbQueue, string, -1, &insertStatementCount, nil) == SQLITE_OK{
            if sqlite3_step(insertStatementCount) == SQLITE_ROW {
                count = Int(sqlite3_column_int(insertStatementCount, 0))
                print("Count Info: \(count)")
            }
        }
        sqlite3_finalize(insertStatementCount)
        sqlite3_close(dbQueue)
        
        return count
    }
    
    class func deleteTablesGps(){
        let dbQueue = DBHelper().db
        
        deleteGpsInfo(db: dbQueue)
        deleteGpsData(db: dbQueue)
        
        sqlite3_close(dbQueue)
        
    }
    
    class func deleteGpsData(db:OpaquePointer?){
        
        let deleteData = "DELETE FROM \(DBHelper.TABLE_GPS_DATA)"
        var deleteStatementData: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteData, -1, &deleteStatementData, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatementData) == SQLITE_DONE {
                print("delete all rows Data OK")
            }else{
                print("delete all rows Data Failed")
            }
        }else{
            print("Prepare delete all Data Fails")
        }
        
        sqlite3_finalize(deleteStatementData)
    }
    
    
    class func deleteGpsInfo(db:OpaquePointer?){
        let deleteInfo = "DELETE FROM \(DBHelper.TABLE_GPS_INFO)"
        var deleteStatementInfo: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteInfo, -1, &deleteStatementInfo, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatementInfo) == SQLITE_DONE {
                print("delete all rows info OK")
            }else{
                print("delete all rows info Failed")
            }
        }else{
            print("Prepare delete all info Fails")
        }
        
        sqlite3_finalize(deleteStatementInfo)
    }
}
