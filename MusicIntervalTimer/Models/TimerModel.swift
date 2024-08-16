//
//  TimerModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import Foundation

struct TimerModel: Codable {
    enum State: Codable {
        case play, pause, stop, none
    }
    enum WorkingState: Codable {
        case rest, work, none
    }
    var id: UUID
    var workTime: Int
    var restTime: Int
    var repeatsCount: Int
    var cyclesCount: Int
    var currentCycle: Int
    var workingState: WorkingState
    var state: State
}
