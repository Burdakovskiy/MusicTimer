//
//  SetupTimerViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

class SetupTimerViewController: UIViewController {
    
    private let setupView = SetupTimerView(frame: .zero)
    private var workMinutes = 0
    private var workSeconds = 0
    private var restMinutes = 0
    private var restSeconds = 0
    private var isWorkFieldSetup = false
    private var isRestFieldSetup = false
    public var tracks: [Track] = []
    
    override func loadView() {
        super.loadView()
        view = setupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    
    private func setupDelegates() {
        setupView.buttonActionsDelegate = self
        setupView.setPickerViewDelegate(self)
    }
    
    private func getTimeInSeconds(for time: String) -> Int {
        let splittedTime = time.split(separator: ":")
        
        let min = Int(String(splittedTime[0]))!
        let sec = Int(String(splittedTime[1]))!
        
        if min == 0 {
            return sec
        } else if sec == 0 {
            return min * 60
        } else {
            return (min * 60) + sec
        }
    }
    
    private func createTimer(from data: (workTime: String,
                                         restTime: String,
                                         repeats: Int,
                                         cycles: Int)) -> TimerModel {
        let workTime = getTimeInSeconds(for: data.workTime)
        let restTime = getTimeInSeconds(for: data.restTime)
        
        let timerModel = TimerModel(id: UUID.init(),
                                    workTime: workTime,
                                    restTime: restTime,
                                    repeatsCount: data.repeats,
                                    cyclesCount: data.cycles,
                                    currentCycle: 1,
                                    workingState: .none,
                                    state: .none)
        return timerModel
    }
    
    private func getTimeString(minutes: Int, seconds: Int) -> String {
        if minutes < 10 {
            if seconds < 10 {
                return "0\(minutes):0\(seconds)"
            }
            return "0\(minutes):\(seconds)"
        } else {
            if seconds < 10 {
                return "\(minutes):0\(seconds)"
            }
            return "\(minutes):\(seconds)"
        }
    }
    
    private func checkSettingUpFields() -> Bool {
        if workMinutes != 0 || workSeconds != 0 {
            isWorkFieldSetup = true
            if restMinutes != 0 || restSeconds != 0 {
                isRestFieldSetup = true
            } else {
                isRestFieldSetup = false
            }
        } else {
            isWorkFieldSetup = false
            if restMinutes != 0 || restSeconds != 0 {
                isRestFieldSetup = true
            } else {
                isRestFieldSetup = false
            }
        }
        return isWorkFieldSetup && isRestFieldSetup
    }
}

extension SetupTimerViewController: ButtonActions {
    func startNextButtonAction(with data: (workTime: String,
                                           restTime: String,
                                           repeats: Int,
                                           cycles: Int)?) {
        if let data {
            let timer = createTimer(from: data)
            let timerVC = TimerViewController()
            timerVC.timerModel = timer
            timerVC.tracks = tracks
            navigationController?.pushViewController(timerVC, animated: true)
        }
    }
    
    
    func addMusicButtonAction() {
        let musicVC = MusicViewController()
        musicVC.onTracksSelected = {[weak self] tracks in
            guard let self else { return }
            self.tracks = tracks
        }
        navigationController?.pushViewController(musicVC, animated: true)
    }
}

extension SetupTimerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let activeTF = setupView.getActiveTFType
        
        switch activeTF {
        case .work:
            if component == 0 {
                workMinutes = row
            } else {
                workSeconds = row
            }
            setupView.setWork(time: getTimeString(minutes: workMinutes, seconds: workSeconds))
            
        case .rest:
            if component == 0 {
                restMinutes = row
            } else {
                restSeconds = row
            }
            setupView.setRest(time: getTimeString(minutes: restMinutes, seconds: restSeconds))
        case .none:
            break
        }
        setupView.checkCorrectFields(isCorrect: checkSettingUpFields())
    }
}
