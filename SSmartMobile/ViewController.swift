//
//  ViewController.swift
//  SSmartMobile
//
//  Created by Christian on 17-12-20.
//  Copyright © 2020 Christian. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    @IBOutlet weak var UIButtonCall: UIButton!
    @IBOutlet weak var UIButtonEmail: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()
        
    }
    
    
    @IBAction func callClick(_ sender: UIButton) {
        if let url = URL(string: "tel://+56933874630") {
            UIApplication.shared.canOpenURL(url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func emailClick(_ sender: UIButton) {
        let email = "mesadeayuda@somax.cl"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    
    func setupBackground(){
        overrideUserInterfaceStyle = .light
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = ["#141d47".color.cgColor, "#3d1e6a".color.cgColor]
        layer.startPoint = CGPoint(x:0,y:0.5)
        layer.endPoint = CGPoint(x:1,y:0.5)
        view.layer.insertSublayer(layer, at: 0)
    }
    
    func setupButtons(){
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
}
