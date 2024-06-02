//
//  FortuneVC.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 5/31/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import Foundation
import UIKit

@objc public class FortunesVC: UITableViewController  {
    let fontAttribution = [NSAttributedString.Key.font: UIFont(name: "WalterTurncoat", size: 18)!]
    let colorAttribution = [NSAttributedString.Key.foregroundColor: UIColor.black]

    var fortunes: [String] = UserDefaults.standard.object(forKey: "fortunes") as! [String]
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fortunes.count
    }
    
    public override func viewDidLoad() {
        self.title = "Fortunes"

        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = fontAttribution
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(fontAttribution, for: .normal)

        let rightButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset(_:)))
        rightButton.setTitleTextAttributes(fontAttribution, for: .normal)
        self.navigationItem.rightBarButtonItems = [rightButton]

        let leftItem = UIBarButtonItem()
        leftItem.title = "Menu"
        leftItem.tintColor = .black
        leftItem.setTitleTextAttributes(fontAttribution, for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = leftItem
        setNavigationBarLook()
    }
    
    func setNavigationBarLook(){
        let shadow = NSShadow()
        shadow.shadowOffset = CGSizeMake(0.0, 1.0)
        shadow.shadowColor = UIColor(named: "gray")
        let shadowAttribution = [NSAttributedString.Key.shadow: shadow]
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = fontAttribution
        UINavigationBar.appearance().titleTextAttributes = shadowAttribution
        UINavigationBar.appearance().titleTextAttributes = colorAttribution
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = fortunes[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: "WalterTurncoat",  size:18.0)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let dvc = DetailVC(nibName: "DetailViewController", bundle: nil)
        dvc.rowOfFortune = indexPath.row
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfSectionsInTableView section: Int) -> Int {
        return 1
    }
 
    @objc func reset(_ sender: UIBarButtonItem) {
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
                    
                @unknown default:
                    print("default")
                }
            }))
        dialog.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        self.present(dialog, animated:true, completion:nil)
    }
    
    private func resetFortunes(){
        UserDefaults.standard.set(Fortunes.resetValues, forKey: "fortunes")
    }
    
}
