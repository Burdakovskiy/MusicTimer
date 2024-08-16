//
//  UIButton+Extesion.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 05.08.2024.
//

import UIKit

extension UIButton {
    convenience init(backgroundImage: UIImage, width: CGFloat) {
        self.init()
        self.setBackgroundImage(backgroundImage, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.tintColor = .systemGreen
    }
}
