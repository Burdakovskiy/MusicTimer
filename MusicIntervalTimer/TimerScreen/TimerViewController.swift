//
//  TimerViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    public var isTemplate = false
    public var timerModel: TimerModel!
    public var timerName: String?
    public var timer: Timer?
    public var tracks: [Track] = []
    
    private let timerView = TimerView(frame: .zero)
    private let alertsFactory = AlertsFactory()
    private let idleDuration = 3
    private var isIdlePhase = true
    private var remainingTime = 0
    private var timerCellModel = [TimerCellModel]()
    private var currentTimerCellModel = [TimerCellModel]()
    private var currentCount = 0
    
    private var audioPlayer: AVAudioPlayer?
    private var isShuffling = false {
        didSet {
            timerView.updateIsShufflingButtonAppearence(with: isShuffling)
        }
    }
    private var isRepeating = false {
        didSet {
            timerView.updateIsRepeatingButtonAppearence(with: isRepeating)
        }
    }
    
    private var isPlaying = true {
        didSet {
            timerView.updateIsPlayingButtonAppearence(with: isPlaying)
        }
    }
    
    private var currentTrackIndex = 0
    
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
        fillTimerCellModel(timer: timerModel)
        updateTableView()
        if timerName != nil {
            title = timerName
        }
        if !isTemplate {
            setupNavigationBar()
        }
        
        if !tracks.isEmpty {
            loadTrack(at: currentTrackIndex)
            audioPlayer?.delegate = self
            startPlaying()
        } else {
            timerView.hideAudioView()
        }
        print(tracks.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startIdlePhase()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    private func loadTrack(at index: Int) {
        guard index >= 0 && index < tracks.count else {
            print("Error at TimerViewController.loadTrack(): invalid track index \(index), track count - \(tracks.count)")
            return
        }
        let track = tracks[index]
        timerView.configureTrackInfo(with: track.title)
        let url = track.fileURL
        print(url)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading track: \(error.localizedDescription)")
        }
    }
    
    private func startPlaying() {
        audioPlayer?.play()
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
    }
    
    private func toggleShuffle() {
        isShuffling.toggle()
        if isShuffling == true && isRepeating == true {
            isRepeating = false
        }
    }
    
    private func toggleRepeat() {
        isRepeating.toggle()
        if isShuffling == true && isRepeating == true {
            isShuffling = false
        }
    }
    
    private func playNextTrack() {
        if isShuffling {
            currentTrackIndex = Int.random(in: 0..<tracks.count)
        } else if isRepeating {
            loadTrack(at: currentTrackIndex)
            startPlaying()
            return
        } else {
            currentTrackIndex = (currentTrackIndex + 1) % tracks.count
        }
        loadTrack(at: currentTrackIndex)
        startPlaying()
    }
    
    private func playPreviousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + tracks.count) % tracks.count
        loadTrack(at: currentTrackIndex)
        startPlaying()
    }
    
    private func startIdlePhase() {
        remainingTime = idleDuration
        timerView.updateTimerLabel(with: remainingTime)
        isIdlePhase = true
        timerView.setTimerAnimation(duration: idleDuration)
        timerView.startBasicAnimation()
        startTimer()
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
    
    private func startNextPhase() {
        if currentCount < timerCellModel.count {
            let currentCellModel = timerCellModel[currentCount]
            if currentCellModel.type == .work || currentCellModel.type == .rest {
                let time = Int(currentCellModel.time) ?? 0
                remainingTime = time
                timerView.setTimerAnimation(duration: time)
                timerView.startBasicAnimation()
                timerView.updateTimerLabel(with: remainingTime, and: timerCellModel[currentCount].color)
                startTimer()
            } else {
                advanceToNextPhase()
            }
        } else {
            stopTimer()
        }
    }
    
    private func advanceToNextPhase() {
        if isIdlePhase {
            isIdlePhase = false
            currentCount = 0
            startNextPhase()
        } else if currentCount < timerCellModel.count {
            currentTimerCellModel.append(timerCellModel[currentCount])
            updateTableView()
            currentCount += 1
            startNextPhase()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(timerTick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func timerTick() {
        if remainingTime > 0 {
            remainingTime -= 1
            timerView.updateTimerLabel(with: remainingTime, and: timerCellModel[currentCount].color)
        }
        if remainingTime == 0 {
            advanceToNextPhase()
        }
    }
    
    private func updateTableView() {
        if !isIdlePhase {
            timerView.reloadData()
            DispatchQueue.main.async {
                if self.currentCount > 0 && self.currentCount <= self.currentTimerCellModel.count {
                    let indexPath = IndexPath(row: self.currentCount - 1, section: 0)
                    self.timerView.scrollTo(row: indexPath)
                }
            }
        }
    }
    
    private func fillTimerCellModel(timer: TimerModel) {
        for _ in 0..<timer.cyclesCount {
            for _ in 0..<(timer.repeatsCount + 1) {
                timerCellModel.append(TimerCellModel(name: "Work", time: String(timer.workTime), type: .work))
                timerCellModel.append(TimerCellModel(name: "Rest", time: String(timer.restTime), type: .rest))
                timerCellModel.append(TimerCellModel(name: "Repeat", time: "", type: .round))
            }
            timerCellModel.append(TimerCellModel(name: "Cycle", time: "", type: .cycle))
        }
    }
}

extension TimerViewController: UITableViewDelegate {}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTimerCellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.cellId, for: indexPath) as! TimerTableViewCell
        let currentState = currentTimerCellModel[indexPath.row]
        cell.configure(with: currentState, index: indexPath.row)
        return cell
    }
}

extension TimerViewController: AudioButtonActions {
    func shuffleButtonAction() {
        toggleShuffle()
    }
    
    func repeatButtonAction() {
        toggleRepeat()
    }
    
    func stopPlayButtonAction() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            isPlaying = true
            startPlaying()
        }
    }
    
    func backwardButtonAction() {
        playPreviousTrack()
    }
    
    func forwardButtonAction() {
        playNextTrack()
    }
}

extension TimerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Flag at TimerViewController.audioPlayerDidFinishPlaying()")
            playNextTrack()
        }
    }
}
