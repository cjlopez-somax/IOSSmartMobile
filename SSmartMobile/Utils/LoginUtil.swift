//
//  LoginUtil.swift
//  SSmartMobile
//
//  Created by Christian on 21-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import Foundation

class LoginUtil {
    
    init() {
    }
    func login(idUser:String, password:String){
        print("login is called")
        let preferences = UserDefaults.standard
        preferences.set(idUser, forKey: Constantes.ID_USER)
        preferences.set(password, forKey: Constantes.PASSWORD)
        preferences.set(true, forKey: Constantes.IS_LOGIN)
    }
    
    func logout(){
        let preferences = UserDefaults.standard
        preferences.set(nil, forKey: Constantes.ID_USER)
        preferences.set(nil, forKey: Constantes.PASSWORD)
        preferences.set(false, forKey: Constantes.IS_LOGIN)
    }
    
    func isLogin() -> Bool{
        let preferences = UserDefaults.standard
        let isLogin = preferences.bool(forKey: Constantes.IS_LOGIN)
        let idUser = preferences.string(forKey: Constantes.ID_USER)
        let password = preferences.string(forKey: Constantes.PASSWORD)
        
        print("idUser: \(String(describing: idUser))  - Password: \(String(describing: password))")
        
        return isLogin && idUser != nil && password != nil
    }
    
    func getIdUser() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: Constantes.ID_USER)!
    }
    
    func getPassword() -> String{
        let preferences = UserDefaults.standard
        return preferences.string(forKey: Constantes.PASSWORD)!
    }
    
    func getUser() -> User{
        return User(id: getIdUser(), pass: getPassword())
    }
}
