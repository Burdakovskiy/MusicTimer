//
//  TimerModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import Foundation

struct TimerModel {
    enum State {
        case play, pause, stop
    }
    enum WorkingState {
        case rest, work
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
