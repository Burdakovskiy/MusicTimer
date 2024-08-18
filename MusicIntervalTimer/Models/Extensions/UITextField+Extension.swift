//
//  UITextField+Extension.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 05.08.2024.
//

import UIKit

extension UITextField {
    convenience init(text: String, width: CGFloat, isEnabled: Bool = true) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.borderStyle = .roundedRect
        self.textAlignment = .center
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.keyboardType = .numberPad
        self.isEnabled = isEnabled
    }
}
