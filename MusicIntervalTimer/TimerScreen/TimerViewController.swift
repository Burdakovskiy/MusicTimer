//
//  TimerViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit
import AVFoundation

final class TimerViewController: UIViewController {
    
    public var isTemplate = false
    public var timerModel: TimerModel!
    public var timerName: String?
    public var tracks: [Track] = []
    
    private let timerView = TimerView(frame: .zero)
    private var timerViewModel: TimerViewModel!
    private let alertsFactory = AlertsFactory()
    
    override func loadView() {
        super.loadView()
        view = timerView
    }
    
    private func setupDelegates() {
        timerView.setTableViewDelegate(self)
        timerView.setTableViewDataSource(self)
        timerView.audioButtonActionsDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupTimerViewModel()
        if timerName != nil {
            title = timerName
        }
        if !isTemplate {
            setupNavigationBar()
        }
        
        if !tracks.isEmpty {
            timerViewModel.activateAudio()
        } else {
            timerView.hideAudioView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timerViewModel.startIdlePhase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerViewModel.stopTimer()
    }
    
    private func setupTimerViewModel() {
        timerViewModel = TimerViewModel(timerModel: timerModel, tracks: tracks)
        
        timerViewModel.onLoadTrack = {[weak self] track in
            guard let self else { return }
            timerView.configureTrackInfo(with: track.title)
        }
        
        timerViewModel.onUpdateTableView = {[weak self] currentCount, currentTimerCellModel in
            guard let self else { return }
            timerView.reloadData()
            DispatchQueue.main.async {
                if currentCount > 0 && currentCount <= currentTimerCellModel.count {
                    let indexPath = IndexPath(row: currentCount, section: 0)
                    self.timerView.scrollTo(row: indexPath)
                }
            }
            
        }
        
        timerViewModel.onPlayerCreated = {[weak self] player in
            player.delegate = self
        }
        
        timerViewModel.onUpdateIsShufflingButtonAppearence = {[weak self] isShuffling in
            guard let self else { return }
            timerView.updateIsShufflingButtonAppearence(with: isShuffling)
        }
        
        timerViewModel.onUpdateIsRepeatingButtonAppearence = {[weak self] isRepeating in
            guard let self else { return }
            timerView.updateIsRepeatingButtonAppearence(with: isRepeating)
        }
        
        timerViewModel.onUpdateIsPlayingButtonAppearence = {[weak self] isPlaying in
            guard let self else { return }
            timerView.updateIsPlayingButtonAppearence(with: isPlaying)
        }
        
        timerViewModel.onUpdateTimerLabel = {[weak self] duration, color in
            guard let self else { return }
            timerView.updateTimerLabel(with: duration, and: color)
        }
        
        timerViewModel.onStartAnimation = {[weak self] duration in
            guard let self else { return }
            timerView.setTimerAnimation(duration: duration)
            timerView.startBasicAnimation()
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveButtonPressed))
    }
    
    @objc private func saveButtonPressed() {
        let alert = alertsFactory.makeAlert(of: .TFAlert(title: "Create template",
                                                         message: "Please enter template name:",
                                                         placeholder: "Name",
                                                         handler: {[weak self] text in
            guard let self else { return }
            let template = TemplateModel(name: text, timer: timerModel, tracks: tracks)
            TemplateStorage.saveTemplate(template)
            let savedAlert = alertsFactory.makeAlert(of: .okAlert(title: "Template successfuly saved", message: nil))
            present(savedAlert, animated: true)
        }))
        present(alert, animated: true)
    }
}

extension TimerViewController: UITableViewDelegate {}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerViewModel.currentTimerCellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.cellId, for: indexPath) as! TimerTableViewCell
        let currentState = timerViewModel.currentTimerCellModel[indexPath.row]
        cell.configure(with: currentState, index: indexPath.row)
        return cell
    }
}

extension TimerViewController: AudioButtonActions {
    func shuffleButtonAction() {
        timerViewModel.toggleShuffle()
    }
    
    func repeatButtonAction() {
        timerViewModel.toggleRepeat()
    }
    
    func stopPlayButtonAction() {
        timerViewModel.playPause()
    }
    
    func backwardButtonAction() {
        timerViewModel.playPreviousTrack()
    }
    
    func forwardButtonAction() {
        timerViewModel.playNextTrack()
    }
}

extension TimerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Flag at TimerViewController.audioPlayerDidFinishPlaying()")
            timerViewModel.playNextTrack()
        }
    }
}
