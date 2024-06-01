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

    public override func viewDidLoad() {
        super.viewDidLoad()
        fortuneTextField.delegate = self
        self.title = "Update Fortune"
        saveButton.setStyle()
        cancelButton.setStyle()
        fortuneTextField.text = getFortune()
        fortuneTextField.font = UIFont(name: "WalterTurncoat", size: 20.0)
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
        print(fortuneTextField?.text)
        print("above: fortune")
        let staticArray = array as NSArray
        UserDefaults.standard.set(staticArray, forKey: "fortunes")
        goHome()
    }
    
    private func goHome(){
        self.navigationController?.popViewController(animated: true)
    }
}
