//
//  UserModel.swift
//  SSmartMobile
//
//  Created by Christian on 21-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case password = "password"
    }
}
