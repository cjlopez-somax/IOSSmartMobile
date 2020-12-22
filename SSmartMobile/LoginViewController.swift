//
//  LoginViewController.swift
//  SSmartMobile
//
//  Created by Christian on 21-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private var alert:UIAlertController?
    @IBOutlet var userInput: UITextField!
    
    @IBOutlet var passwordInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LoginUtil().isLogin() {
            self.goToMainActivity()
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginClick(_ sender: Any) {
        
        if userInput.text?.isEmpty == true || passwordInput.text?.isEmpty == true {
            print("User or password is empty")
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
    
    func loginUser(idUser:String, password:String){
        let url = String( format : Constantes.SERVERBASE_URL + "login")
        guard let serviceUrl = URL(string: url) else { return }
        var urlRequest = URLRequest(url: serviceUrl)
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
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("No valid response")
                return
            }
            switch httpResponse.statusCode {
                case 200:
                    do {
                        //let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let user = try JSONDecoder().decode(User.self, from: data)
                        print("userID: \(user.id)")
                        LoginUtil().login(idUser: idUser, password: password)
                        goToMainActivity()
                    } catch {
                        print(error)
                    }
                case 401:
                    print("Error on login")
                
                default:
                    return
            }
            
                
            }.resume()
        
        
        
    }
    
    func dismissLoading(){
        DispatchQueue.main.async {
            self.alert?.dismiss(animated: false, completion: nil)
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
    

}
