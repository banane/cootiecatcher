//
//  MainController.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 5/31/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import Foundation
import UIKit

@objc class MainController: UIViewController {
    @IBOutlet retain var blueButton: UIButton!
    @IBOutlet retain var yellowButton: UIButton!
    @IBOutlet retain var redButton: UIButton!
    @IBOutlet retain var greenButton: UIButton!
    @IBOutlet retain var againButton: UIButton!
    @IBOutlet retain var settingsButton: UIButton!
    @IBOutlet retain var fortuneLabel: UILabel!
        
    @IBOutlet retain var closedImageView: UIImageView!

    
    var fortuneArray: NSMutableArray
    var imgNumsArray: NSArray
    var masterImageArray: NSArray
    var colors: NSArray
    

    @IBAction func click(id: int) {
        
    }
    
    @IBAction func playAgain() {
        
    }
    
    @IBAction func clickSettings() {
        
    }


}
