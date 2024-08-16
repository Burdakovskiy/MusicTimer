//
//  SetupTimerViewModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import Foundation

final class SetupTimerViewModel {
    private var workMinutes = 0
    private var workSeconds = 0
    private var restMinutes = 0
    private var restSeconds = 0
    
    func getTimeInSeconds(for time: String) -> Int {
        
    }
    
    func getTimeString(minutes: Int, seconds: Int) -> String {
        return ""
    }
    
    func createTimer(from data: (workTime: String, restTime: String, repeats: Int, cycles: Int)) -> TimerModel {
        
    }
    
    func checkSettingUpFields() -> Bool {
        return true
    }
    
    func updateWorkTime(minutes: Int, seconds: Int) {
        self.workMinutes = minutes
        self.workSeconds = seconds
    }
    
    func updateRestTime(minutes: Int, seconds: Int) {
        self.restMinutes = minutes
        self.restSeconds = seconds
    }
}
