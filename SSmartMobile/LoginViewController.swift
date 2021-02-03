//
//  LoginViewController.swift
//  SSmartMobile
//
//  Created by Christian on 21-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import UIKit
import MessageUI

class LoginViewController: UIViewController, MFMailComposeViewControllerDelegate {

    private var alert:UIAlertController?
    @IBOutlet var userInput: UITextField!
    
    @IBOutlet var UIButtonLogin: UIButton!
    @IBOutlet var UIButtonCall: UIButton!
    @IBOutlet var UIButtonEmail: UIButton!
    @IBOutlet var passwordInput: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = ["#141d47".color.cgColor, "#3d1e6a".color.cgColor]
        layer.startPoint = CGPoint(x:0,y:0.5)
        layer.endPoint = CGPoint(x:1,y:0.5)
        view.layer.insertSublayer(layer, at: 0)
        if LoginUtil().isLogin() {
            self.goToMainActivity()
        }else{
            VariablesUtil.resetVariables()
        }
        
        UIButtonLogin.backgroundColor = "#E8B321".color
        UIButtonLogin.layer.cornerRadius = 5
        UIButtonLogin.setTitleColor("#231198".color, for: .normal)
        
        UIButtonCall.backgroundColor = "#E8B321".color
        UIButtonCall.layer.cornerRadius = 5
        UIButtonCall.setTitleColor("#231198".color, for: .normal)
        UIButtonCall.tintColor = UIColor.white
        UIButtonCall.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        UIButtonEmail.backgroundColor = "#E8B321".color
        UIButtonEmail.layer.cornerRadius = 5
        UIButtonEmail.setTitleColor("#231198".color, for: .normal)
        UIButtonEmail.tintColor = UIColor.white
        UIButtonEmail.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    @IBAction func buttonNext(_ sender: Any) {
        print("user trigger")
        passwordInput.becomeFirstResponder()
    }
    
    
    @IBAction func passwordTrigger(_ sender: Any) {
        print("passwrod trigger")
        loginClick(sender)
    }
    
    
    @IBAction func loginClick(_ sender: Any) {
        
        if userInput.text?.isEmpty == true || passwordInput.text?.isEmpty == true {
            print("User or password is empty")
            GeneralFunctions.showToast(controller: self, message: "Debe completar todos los campos...", seconds: 2)
            return
        }
        alert = UIAlertController(title: nil, message: "Espera Por favor...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert?.view.addSubview(loadingIndicator)
        present(alert!, animated: true, completion: nil)
        loginUser(idUser: userInput.text!, password: passwordInput.text!)
        
        
    }
    @IBAction func callClick(_ sender: UIButton) {
        print("callButton is click")
        if let url = URL(string: "tel://+56933874630") {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    @IBAction func mailClick(_ sender: UIButton) {
        print("mailButton is click")
        
        let email = "mesadeayuda@somax.cl"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
        
    }
    func loginUser(idUser:String, password:String){
        let url = String( format : Constantes.SERVERBASE_URL + "global_transmision/autentificarSesionMovil")
        let urlComponents = NSURLComponents(string: url)!

        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: userInput.text),
            URLQueryItem(name: "pass", value: passwordInput.text),
        ]
        //guard let serviceUrl = URL(string: url) else { return }
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let dataDictionary = ["id":userInput.text,"password":passwordInput.text]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dataDictionary, options: []) else {
                return
            }
        urlRequest.httpBody = httpBody
        urlRequest.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { [self] (data, response, error) in
            dismissLoading()
            print("Error:  \(String(describing: error))")
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("No valid response")
                return
            }
            switch httpResponse.statusCode {
                case 200:
                    do {
                        let loginResult = try JSONDecoder().decode(LoginResult.self, from: data)
                        print(loginResult.estado)
                        if loginResult.estado == 1 && loginResult.cluster == 1 {
                            LoginUtil().login(idUser: idUser, password: password)
                            ConfigController().getConfig()
                            goToMainActivity()
                        }else{
                            print("Error on login")
                            DispatchQueue.main.async {
                                GeneralFunctions.showToast(controller: self, message: "Usuario o Contraseña incorrecta...", seconds: 2)
                            }
                            
                        }
                        
                    } catch {
                        print(error)
                        DispatchQueue.main.async {
                            GeneralFunctions.showToast(controller: self, message: "Problemas con el servidor. Por favor intente nuevamente más tarde...", seconds: 3)
                        }
                        
                    }
                    
                    
                
                default:
                    DispatchQueue.main.async {
                        GeneralFunctions.showToast(controller: self, message: "Problemas con el servidor. Por favor intente nuevamente más tarde...", seconds: 3)
                    }
                    return
            }
            
                
            }.resume()
        
        
        
    }
    
    func dismissLoading(){
        DispatchQueue.main.async {
            self.alert?.dismiss(animated: false, completion: nil)
        }
    }
    
    func goToMap(){
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "map")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func goToMainActivity(){
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "main")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
    

}

extension String {

var color: UIColor {
    let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

    if #available(iOS 13, *) {
        //If your string is not a hex colour String then we are returning white color. you can change this to any default colour you want.
        guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1) }

        let a, r, g, b: Int32
        switch hex.count {
        case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
        case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
        case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
        default:    (a, r, g, b) = (255, 0, 0, 0)
        }

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)

    } else {
        var int = UInt32()

        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
        case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
        case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
        default:    (a, r, g, b) = (255, 0, 0, 0)
        }

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
  }
}

extension ViewController : MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let  _ = error {
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("canceled")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        case .failed:
            print("failed")
        @unknown default:
            print("default")
        }
        
        controller.dismiss(animated: true)
    }
}

