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
    
    private var isWorkFieldSetup: Bool {
        return workMinutes != 0 || workSeconds != 0
    }
    
    private var isRestFieldSetup: Bool {
        return restMinutes != 0 || restSeconds != 0
    }
    
    private func getTimeInSeconds(for time: String) -> Int {
        let splittedTime = time.split(separator: ":")
        
        let min = Int(String(splittedTime[0]))!
        let sec = Int(String(splittedTime[1]))!
        
        return (min * 60) + sec
    }
    
    public func getTimeString(minutes: Int, seconds: Int) -> String {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    public func getWorkTimeString() -> String {
        return getTimeString(minutes: workMinutes, seconds: workSeconds)
    }
    
    public func getRestTimeString() -> String {
        return getTimeString(minutes: restMinutes, seconds: restSeconds)
    }
    
    public func createTimer(from data: (workTime: String, restTime: String, repeats: Int, cycles: Int)) -> TimerModel {
        let workTime = getTimeInSeconds(for: data.workTime)
        let restTime = getTimeInSeconds(for: data.restTime)
        
        return TimerModel(id: UUID.init(),
                          workTime: workTime,
                          restTime: restTime,
                          repeatsCount: data.repeats,
                          cyclesCount: data.cycles,
                          currentCycle: 1,
                          workingState: .none,
                          state: .none)
    }
    
    
    public func updateWork(minutes: Int) {
        self.workMinutes = minutes
    }
    
    public func updateWork(seconds: Int) {
        self.workSeconds = seconds
    }
    
    public func updateRest(minutes: Int) {
        self.restMinutes = minutes
    }
    
    public func updateRest(seconds: Int) {
        self.restSeconds = seconds
    }
    
    public func checkSettingUpFields() -> Bool {
        return isWorkFieldSetup && isRestFieldSetup
    }
}
