//
//  TemplateModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import Foundation

struct TemplateModel: Codable {
    var name: String
    let timer: TimerModel
    var tracks: [Track]
}
