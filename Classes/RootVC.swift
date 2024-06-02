//
//  RootVC.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 6/1/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import Foundation
import UIKit

@objc public class RootVC: UIViewController {
    @IBOutlet var blueButton: UIButton?
    @IBOutlet var yellowButton: UIButton?
    @IBOutlet var redButton: UIButton?
    @IBOutlet var greenButton: UIButton?
    
    @IBOutlet var settingsBtn: UIButton?
    @IBOutlet var againBtn: UIButton?
    
    @IBOutlet var fortuneLabel: UILabel?
        
    @IBOutlet var closedImageView: UIImageView?
    
    @objc @IBAction func click(_ sender: UIButton){
        print(sender.tag)
//        int buttonInt = (int *)[sender tag];
//        int flipTimes = 0;
//        
//        if(stage == 0) {                        //color round- the char length of the word
//            flipTimes = (int *)[[colors objectAtIndex:buttonInt] length];
//        } else {                                // all other rounds interpret the id to displayed numbers based on state
//            flipTimes = [[[imgNumsArray objectAtIndex:lastState] objectAtIndex:buttonInt] intValue];
//        }
//
//        if (stage < 2) {
//            [self animateToy:flipTimes];
//            [self playSound];
//        } else if (stage == 2) {
//            [self revealFortune:flipTimes];
//        }
    }
    
    @objc @IBAction func playAgain(_ sender: UIButton){
        
    }
    
    @objc @IBAction func seeSettings(_ sender: UIButton){
        let menuVC = MenuVC(nibName: "MenuViewController", bundle: nil)
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func animateToy(){
        
    }
    
    func playSound(){
        
    }
    
    func revealFortune(fortune: String){
        
    }
    
    
}
