//
//  TimerCellModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 07.08.2024.
//

import UIKit


enum TimerCellType {
    case work
    case rest
    case round
    case cycle
}

struct TimerCellModel {
    let name: String
    let time: String
    let type: TimerCellType
    var color: UIColor {
        switch type {
        case .work:
            return UIColor.red
        case .rest:
            return UIColor.yellow
        case .round:
            return UIColor.gray
        case .cycle:
            return UIColor.green
        }
    }
}
