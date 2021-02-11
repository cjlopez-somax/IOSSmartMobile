//
//  GpsController.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation
class GpsController {
    
    init() {
        
    }
    
    func post(gpsData: GpsData){
        print("postData is called")
        textLog.write("postData is called")
        let url = String( format : Constantes.SERVERBASE_URL + "flota/saveApplicationGps")
        let urlComponents = NSURLComponents(string: url)!
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: LoginUtil.getIdUser()),
            URLQueryItem(name: "pass", value: LoginUtil.getPassword()),
        ]
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONEncoder().encode(gpsData) else {
                return
            }
        urlRequest.httpBody = httpBody
        urlRequest.timeoutInterval = 60
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("No valid response")
                textLog.write("No valid response")
                GpsSqlite.insertGpsData(gpsData: gpsData)
                return
            }
            print("Code \(httpResponse.statusCode)")
            textLog.write("Code \(httpResponse.statusCode)")
            switch httpResponse.statusCode {
                case 200:
                    do {
                        let gpsResponse = try JSONDecoder().decode(GpsResponse.self, from: data)
                        print("gpsResponse: \(gpsResponse.respond)")
                        textLog.write("gpsResponse: \(gpsResponse.respond)")
                        self.checkDetectDriveRespServer(respond: gpsResponse.respond)
                    } catch {
                        print(error)
                    }
                    print("GPS Guardado")
                    textLog.write("GPS Guardado")
                
                default:
                    print("Error on response")
                    
                    textLog.write("Error on response")
                    GpsSqlite.insertGpsData(gpsData: gpsData)
                    return
            }
            
                
            }.resume()
        
    }
    
    func postGpsPending(gpsDataList: [GpsData]){
        print("postDataList is called")
        textLog.write("postDataList is called")
        let url = String( format : Constantes.SERVERBASE_URL + "flota/saveApplicationGpsHistory")
        let urlComponents = NSURLComponents(string: url)!
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: LoginUtil.getIdUser()),
            URLQueryItem(name: "pass", value: LoginUtil.getPassword()),
        ]
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONEncoder().encode(gpsDataList) else {
                return
            }
        urlRequest.httpBody = httpBody
        urlRequest.timeoutInterval = 60
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("No valid response Gps", to:&textLog)
                return
            }
            print("Code \(httpResponse.statusCode)" )
            switch httpResponse.statusCode {
                case 200:
                    do {
                        let gpsResponse = try JSONDecoder().decode(GpsResponse.self, from: data)
                        print("gpsResponse: \(gpsResponse.respond)")
                        textLog.write("gpsResponse: \(gpsResponse.respond)")
                        //self.checkDetectDriveRespServer(respond: gpsResponse.respond)
                        // Eliminar Datos de Gps
                        GpsSqlite.deleteGpsPendingSaved(gpsDataList: gpsDataList)
                    } catch {
                        print(error)
                    }
                    print("GPS Pending Response OK")
                
                default:
                    print("Error on response Pending")
                    textLog.write("Error on response Pending")
                    return
            }
            
                
            }.resume()
    }
    
    func checkDetectDriveRespServer(respond: Int){
        let oldDetectDrive = DriveUtil.getDetectDriveState()
        
        switch respond {
        case 0:
            if oldDetectDrive != 0 {
                DriveUtil.setDetectDriveState(detectDriveState: respond)
            }
            break
        case 1:
            VariablesUtil.setDetectDriveDate()
            if oldDetectDrive == 0 {
                DriveUtil.setDetectDriveState(detectDriveState: respond)
                VariablesUtil.setDD1Times(dd1Times: 1)
            }else if oldDetectDrive == 1 {
                DriveUtil.setDetectDriveState(detectDriveState: respond)
                VariablesUtil.addDD1Times()
            }
            else if oldDetectDrive == 2 {
                // Change to DD3
                DriveUtil.setDetectDriveState(detectDriveState: 3)
                print("ChangeToDD3 from respond 1 and oldDetectDrive 2")
                textLog.write("ChangeToDD3 from respond 1 and oldDetectDrive 2")
            }
            break
        case 2:
            if oldDetectDrive == 0 || oldDetectDrive == 1 {
                DriveUtil.setDetectDriveState(detectDriveState: respond)
                VariablesUtil.setDD2Times(dd2Times: 1)
            }else if oldDetectDrive == 2{
                DriveUtil.setDetectDriveState(detectDriveState: respond)
                VariablesUtil.addDD2Times()
            }
            
            break
        case 3:
            // Change To DD3
            DriveUtil.setDetectDriveState(detectDriveState: 3)
            print("ChangeToDD3 from respond 3")
            textLog.write("ChangeToDD3 from respond 3")
            break
        default:
            break
        }
    }
    
}
