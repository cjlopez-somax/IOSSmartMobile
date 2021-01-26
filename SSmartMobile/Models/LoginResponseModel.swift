//
//  LoginResponseModel.swift
//  SSmartMobile
//
//  Created by Christian on 25-01-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import Foundation

struct LoginResult: Decodable {
    var estado: Int
    var cluster: Int?
    
}
