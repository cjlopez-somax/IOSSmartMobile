//
//  HttpInstance.swift
//  SSmartMobile
//
//  Created by Christian on 22-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

class HttpInstance {
    init() {
        
    }
    
    func post(endPoint: String) -> URLRequest{
        let url = String( format : Constantes.SERVERBASE_URL + "login")
        let serviceUrl = URL(string: url)
        var urlRequest = URLRequest(url: serviceUrl!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 20
        
        return urlRequest
    }
}
