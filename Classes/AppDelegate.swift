//
//  AppDelegate.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 6/2/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import Foundation
import UIKit

@UIApplicationMain

@objc class AppDelegate: UIResponder, UIApplicationDelegate  {
    var window: UIWindow?
    
    @objc func applicationDidFinishLaunching(_ application: UIApplication) {        
        let rvc: RootVC = RootVC(nibName: "RootViewController", bundle: nil)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let navCtrl = UINavigationController()
        navCtrl.viewControllers = [rvc]
        self.window!.rootViewController = navCtrl
        self.window?.makeKeyAndVisible()
        setupDb()
        setNavigationBarLook()
    }
    
    func setupDb(){
        let fortunes = UserDefaults.standard.object(forKey: "fortunes") as! [String]
        if fortunes.count == 0 {
            UserDefaults.standard.set(Fortunes.resetValues, forKey: "fortunes")
        }
    }
    func setNavigationBarLook(){
        let shadow = NSShadow()
       
        let fontAttribution = [NSAttributedString.Key.font: UIFont(name: "WalterTurncoat", size: 18)!]
        shadow.shadowOffset = CGSizeMake(0.0, 1.0)
        shadow.shadowColor = UIColor(named: "gray")
        let shadowAttribution = [NSAttributedString.Key.shadow: shadow]
        let colorAttribution = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = fontAttribution
        UINavigationBar.appearance().titleTextAttributes = shadowAttribution
        UINavigationBar.appearance().titleTextAttributes = colorAttribution
    }
}
