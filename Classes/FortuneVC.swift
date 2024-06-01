//
//  FortuneVC.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 5/31/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import Foundation
import UIKit

@objc public class FortunesVC: UITableViewController {
 
    @IBAction public func reset() {
        let dialog = UIAlertController(title:"Reset Fortunes?", message:"Go back to preset fortunes. You will lose all of your typed in fortunes...", preferredStyle: .alert)

        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
                switch action.style {
                        case .default:
                            self.resetFortunes()
                        
                        case .cancel:
                        print("cancel")
                        
                        case .destructive:
                        print("destructive")
                    
                }
            }))
        dialog.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        self.present(dialog, animated:true, completion:nil)
    }
    
    private func resetFortunes(){
        UserDefaults.standard.set(Fortunes.resetValues, forKey: "fortunes")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
