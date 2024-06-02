//
//  DetailVC.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 5/31/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import Foundation
import UIKit


@objc public class DetailVC: UIViewController, UITextFieldDelegate {
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var fortuneTextField: UITextField!
    @objc public var rowOfFortune: Int = 0
    
    let fontAttribution = [NSAttributedString.Key.font: UIFont(name: "WalterTurncoat", size: 18)!]
    let colorAttribution = [NSAttributedString.Key.foregroundColor: UIColor.white]


    public override func viewDidLoad() {
        super.viewDidLoad()
        fortuneTextField.delegate = self
        self.title = "Update Fortune"
        saveButton.setStyle()
        cancelButton.setStyle()
        fortuneTextField.text = getFortune()
        fortuneTextField.font = UIFont(name: "WalterTurncoat", size: 20.0)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = fontAttribution
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(fontAttribution, for: .normal)

        let leftItem = UIBarButtonItem()
        leftItem.title = "Fortunes"
        leftItem.tintColor = .white
        leftItem.setTitleTextAttributes(fontAttribution, for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = leftItem
        setNavigationBarLook()
    }
    
    func setNavigationBarLook(){
        let shadow = NSShadow()
        shadow.shadowOffset = CGSizeMake(0.0, 1.0)
        shadow.shadowColor = UIColor(named: "gray")
        let shadowAttribution = [NSAttributedString.Key.shadow: shadow]
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = fontAttribution
        UINavigationBar.appearance().titleTextAttributes = shadowAttribution
        UINavigationBar.appearance().titleTextAttributes = colorAttribution
    }
    
    private func getFortune() -> String{
        let array = UserDefaults.standard.object(forKey:"fortunes") as? [String] ?? [String]()
        return array[rowOfFortune]
    }
    
    @IBAction func cancel(){
        goHome()
    }
    
    @IBAction func save(){
        var array = UserDefaults.standard.object(forKey:"fortunes") as? [String] ?? [String]()
        array[rowOfFortune] = fortuneTextField.text ?? ""
        let staticArray = array as NSArray
        UserDefaults.standard.set(staticArray, forKey: "fortunes")
        goHome()
    }
    
    private func goHome(){
        self.navigationController?.popViewController(animated: true)
    }
}
