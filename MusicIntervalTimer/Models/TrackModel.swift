//
//  TrackModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 12.08.2024.
//

import Foundation

struct Track: Codable {
    let title: String
    let duration: TimeInterval
    let fileURL: URL
}
