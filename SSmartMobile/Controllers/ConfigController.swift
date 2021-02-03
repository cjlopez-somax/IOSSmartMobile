//
//  ConfigController.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

class ConfigController{
    
    init() {
        
    }
    
    func getConfig(){
        print("getConfig is called")
        let url = String( format : Constantes.SERVERBASE_URL + "flota/getApplicationsSetting")
        let urlComponents = NSURLComponents(string: url)!
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: LoginUtil().getIdUser()),
            URLQueryItem(name: "pass", value: LoginUtil().getPassword()),
        ]
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let dataDictionary = ["id":LoginUtil().getIdUser(),"password":LoginUtil().getPassword()]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dataDictionary, options: []) else {
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
            switch httpResponse.statusCode {
                case 200:
                    do {
                        let config = try JSONDecoder().decode(Config.self, from: data)
                        
                        if ConfigUtil().validateConfig(config: config){
                            print("ValidateConfig OK")
                            ConfigUtil().setLastConfigUpdateDate(date: GeneralFunctions.getCurrentTime())
                            ConfigUtil().saveConfig(config: config)
                            
                            
                        }else{
                            print("ValidaConfig Error")
                        }
                        
                        
                        print(config)
                    } catch {
                        print(error)
                    }
                
                default:
                    return
            }
            
                
            }.resume()
    }
}
