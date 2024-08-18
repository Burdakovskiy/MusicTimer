//
//  UILabel+Extension.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 05.08.2024.
//

import UIKit

extension UILabel {
    convenience init(text: String, fontSize: CGFloat) {
        self.init()
        self.text =  text
        self.font = .systemFont(ofSize: fontSize)
    }
}
