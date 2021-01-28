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
        print("getConfig is called")
        let url = String( format : Constantes.SERVERBASE_URL + "flota/saveApplicationGps")
        guard let serviceUrl = URL(string: url) else { return }
        var urlRequest = URLRequest(url: serviceUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONEncoder().encode(gpsData) else {
                return
            }
        urlRequest.httpBody = httpBody
        urlRequest.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            print("Error:  \(String(describing: error))")
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("No valid response")
                return
            }
            print("Code \(httpResponse.statusCode)" )
            switch httpResponse.statusCode {
                case 200:
                    do {
                        let gpsResponse = try JSONDecoder().decode(GpsResponse.self, from: data)
                        DriveUtil.setDetectDriveState(detectDriveState: gpsResponse.respond)
                        print("gpsResponse: \(gpsResponse.respond)")
                    } catch {
                        print(error)
                    }
                    print("GPS Guardado")
                
                default:
                    print("Error on response")
                    return
            }
            
                
            }.resume()
        
    }
    
}
