//
//  SetupTimerViewModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import Foundation

final class SetupTimerViewModel {
    
//MARK: - Properties
    
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

//MARK: - Functions
    
    private func getTimeInSeconds(for time: String) -> Int {
        let splittedTime = time.split(separator: ":")
        
        let min = Int(String(splittedTime[0]))!
        let sec = Int(String(splittedTime[1]))!
        
        return (min * 60) + sec
    }
    
    func getTimeString(minutes: Int, seconds: Int) -> String {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func getWorkTimeString() -> String {
        return getTimeString(minutes: workMinutes, seconds: workSeconds)
    }
    
    func getRestTimeString() -> String {
        return getTimeString(minutes: restMinutes, seconds: restSeconds)
    }
    
    func updateWork(minutes: Int) {
        self.workMinutes = minutes
    }
    
    func updateWork(seconds: Int) {
        self.workSeconds = seconds
    }
    
    func updateRest(minutes: Int) {
        self.restMinutes = minutes
    }
    
    func updateRest(seconds: Int) {
        self.restSeconds = seconds
    }
    
    func checkSettingUpFields() -> Bool {
        return isWorkFieldSetup && isRestFieldSetup
    }
    
    func createTimer(from data: (workTime: String, restTime: String, repeats: Int, cycles: Int)) -> TimerModel {
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
}
