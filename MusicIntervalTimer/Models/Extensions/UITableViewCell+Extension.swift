//
//  UITableView+Extension.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import UIKit

extension UITableViewCell {
    static var cellId: String {
        return self.description()
    }
}
