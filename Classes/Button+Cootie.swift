//
//  Button+Cootie.swift
//  Cootie
//
//  Created by ANNA BILLSTROM on 5/31/24.
//  Copyright © 2024 banane.com. All rights reserved.
//

import UIKit

@objc extension UIButton {
    @objc func setStyle() {
        titleLabel?.font = UIFont(name: "WalterTurncoat", size: 18.0)
        let padding_button: Float = 6.0
        let titleInsets = UIEdgeInsets(top: 0.0, left: CGFloat(padding_button), bottom: 0.0, right: CGFloat(-padding_button))
        let contentInsets = UIEdgeInsets(top: CGFloat(padding_button), left: 0.0, bottom: CGFloat(padding_button), right: 0.0)
    }
}
