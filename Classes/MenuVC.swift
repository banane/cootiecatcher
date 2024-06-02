//
//  MenuVC.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 6/1/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import Foundation
import UIKit

@objc public class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = titles[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: "WalterTurncoat",  size:18.0)
        return cell
    }
    
    @IBOutlet public var tableView: UITableView?
    var titles: [String] = ["About Cootie", "Contact Us", "Fortunes"]
    
    public override func viewDidLoad() {
        self.title = "Menu"
        let fontAttribution = [NSAttributedString.Key.font: UIFont(name: "WalterTurncoat", size: 18)!]
        let colorAttribution = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = fontAttribution
        self.navigationController?.navigationBar.titleTextAttributes = colorAttribution

        let leftItem = UIBarButtonItem()
        leftItem.title = "Cootie"
        UIBarButtonItem.appearance().tintColor = .white
        leftItem.setTitleTextAttributes(fontAttribution, for: .normal)
        leftItem.setTitleTextAttributes(colorAttribution, for: .normal)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = leftItem
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, numberOfSectionsInTableView section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        switch indexPath.row {
            case 0:
                showAlert()
            case 1:
                print("contact cootie")
            case 2:
                showFortunes()
        default:
            print("something happened")
        }
    }
    
    func showFortunes(){
        var fvc = FortunesVC(nibName: "FortuneViewController", bundle: nil)
        self.navigationController?.pushViewController(fvc, animated: true)
    }
    
    func showAlert(){
        let dialog = UIAlertController(title:"About CootieCatcher",
                                       message:"By Anna Billstrom, with some help from her big sister Jennifer Huber.",
                                       preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Cool", style: .default))
        self.present(dialog, animated:true, completion:nil)
    }
}

