//
//  RootVC.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 6/1/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

@objc public class RootVC: UIViewController {
    @IBOutlet var blueButton: UIButton?
    @IBOutlet var yellowButton: UIButton?
    @IBOutlet var redButton: UIButton?
    @IBOutlet var greenButton: UIButton?
    
    @IBOutlet var menuBtn: UIButton?
    @IBOutlet var againBtn: UIButton?
    
    @IBOutlet var fortuneLabel: UILabel?
    
    @IBOutlet var closedImageView: UIImageView?
    
    var mysound: SystemSoundID = 0
    
    var state: Int = 0
    var lastState = 0
    
    let colors: [String] = ["red", "green", "blue", "yellow"]
    let imageNumsArray: [[Int]] = [
        [1,6,5,2], [8,7,4,3]
    ] // represent wide and tall number visuals
    
    var imageNames = ["tall", "wide", "closed"]
    var stage = 0
    
    
    let soundPath = Bundle.main.path(forResource: "cootie", ofType: "wav")
    
    override public func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.title = "Cootie"
        self.navigationItem.titleView?.tintColor = .white
        
    }
    
    @objc @IBAction func click(_ sender: UIButton){
        print(sender.tag)
        let buttonInt = sender.tag as Int
        var flipTimes = 0
        if(stage == 0){
            flipTimes = colors[buttonInt].count
        } else {
            flipTimes = imageNumsArray[lastState][buttonInt]
        }
        
        if (stage < 2) {
            animateToy(flipTimes: flipTimes)
            playSound()
        } else if (stage == 2) {
            revealFortune(fortuneID: flipTimes)
        }
    }
    
    @objc @IBAction func playAgain(_ sender: UIButton){
        closedImageView?.animationImages = nil
        closedImageView?.image = UIImage(named: imageNames[2])
        fortuneLabel?.isHidden = true
        againBtn?.isEnabled = false
        closedImageView?.isHidden = false
        redButton?.isHidden = false
        blueButton?.isHidden = false
        greenButton?.isHidden = false
        yellowButton?.isHidden = false
        stage = 0
        lastState = 0
        
    }
    
    @IBAction func seeMenu(_ sender: UIButton){
        let menuVC = MenuVC(nibName: "MenuViewController", bundle: nil)
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func animateToy(flipTimes: Int){
        var alternator = lastState
        var animationArray = [UIImage]()
        for number in 0...flipTimes {
            alternator ^= 1
            animationArray.append(UIImage(named: imageNames[alternator])!)
            if(number<flipTimes && number != flipTimes){
                animationArray.append(UIImage(named: imageNames[2])!)
            }
        }
        let duration = 0.2 * Double(animationArray.count)
        lastState = alternator
        closedImageView?.animationImages = nil
        closedImageView?.animationImages = animationArray
        closedImageView?.animationDuration = TimeInterval(duration)
        closedImageView?.animationRepeatCount = 1
        self.perform(#selector(cootieAnimationStopped), with: nil, afterDelay: duration)
        
        closedImageView?.startAnimating()
        stage += 1
    }
    
    @objc func cootieAnimationStopped(){
        closedImageView?.animationImages = nil
        closedImageView?.image = UIImage(named: imageNames[lastState])
    }
    
    func playSound(){
        AudioServicesPlaySystemSound(mysound)
    }
    
    func revealFortune(fortuneID: Int){
        let indexFortune = fortuneID - 1
        let fortunes = UserDefaults.standard.object(forKey: "fortunes") as! [String]
        let fortuneString: String = fortunes[indexFortune]
        fortuneLabel?.text = fortuneString
        fortuneLabel?.isHidden = false
        againBtn?.isEnabled = true
    }
}
