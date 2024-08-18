//
//  UIStackView+Extension.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 05.08.2024.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView],
                     spacing: CGFloat,
                     axis: NSLayoutConstraint.Axis,
                     distribution: UIStackView.Distribution = .fill) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = spacing
        self.axis = axis
        self.distribution = distribution
    }
}
