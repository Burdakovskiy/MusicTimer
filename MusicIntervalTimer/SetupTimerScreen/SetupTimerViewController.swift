//
//  SetupTimerViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

final class SetupTimerViewController: UIViewController {
    
//MARK: - Properties
    
    private let setupView = SetupTimerView(frame: .zero)
    private let setupViewModel = SetupTimerViewModel()
    private var tracks: [Track] = []
    
    
//MARK: - Functions
    
    private func setupDelegates() {
        setupView.buttonActionsDelegate = self
        setupView.setPickerViewDelegate(self)
    }
    
    override func loadView() {
        super.loadView()
        view = setupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
}

//MARK: - ButtonActions
extension SetupTimerViewController: ButtonActions {
    func startNextButtonAction(with data: (workTime: String,
                                           restTime: String,
                                           repeats: Int,
                                           cycles: Int)?) {
        if let data {
            let timer = setupViewModel.createTimer(from: data)
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

//MARK: - UIPickerViewDelegate
extension SetupTimerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let activeTF = setupView.getActiveTFType
        
        switch activeTF {
        case .work:
            if component == 0 {
                setupViewModel.updateWork(minutes: row)
            } else {
                setupViewModel.updateWork(seconds: row)
            }
            setupView.setWork(time: setupViewModel.getWorkTimeString())
            
        case .rest:
            if component == 0 {
                setupViewModel.updateRest(minutes: row)
            } else {
                setupViewModel.updateRest(seconds: row)
            }
            setupView.setRest(time: setupViewModel.getRestTimeString())
        case .none:
            break
        }
        setupView.checkCorrectFields(isCorrect: setupViewModel.checkSettingUpFields())
    }
}
