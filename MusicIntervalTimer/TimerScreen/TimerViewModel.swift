//
//  TimerViewModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 18.08.2024.
//

import UIKit
import AVFoundation

final class TimerViewModel {
    
//MARK: - Initializers
    
    init(timerModel: TimerModel, tracks: [Track]) {
        self.timerModel = timerModel
        self.tracks = tracks
        fillTimerCellModel(timer: timerModel)
    }
    
//MARK: - Properties
    
    private var timerModel: TimerModel
    private let idleDuration = 3
    private var isIdlePhase = true
    private var remainingTime = 0
    private var timerCellModel = [TimerCellModel]()
    private var currentCount = 0
    private var tracks: [Track] = []
    private var audioPlayer: AVAudioPlayer?
    private var isShuffling = false
    private var isRepeating = false
    private var isPlaying = true
    private var currentTrackIndex = 0
    private(set) var currentTimerCellModel = [TimerCellModel]()
    
    var timer: Timer?
    
    var onLoadTrack: ((Track) -> Void)?
    var onUpdateIsShufflingButtonAppearence: ((Bool) -> Void)?
    var onUpdateIsRepeatingButtonAppearence: ((Bool) -> Void)?
    var onUpdateIsPlayingButtonAppearence: ((Bool) -> Void)?
    var onUpdateTimerLabel: ((Int, UIColor) -> Void)?
    var onUpdateTableView: ((Int, [TimerCellModel]) -> Void)?
    var onPlayerCreated: ((AVAudioPlayer) -> Void)?
    var onStartAnimation: ((Int) -> Void)?
    
//MARK: - Functions
    
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
    
    private func loadTrack(at index: Int) {
        guard index >= 0 && index < tracks.count else {
            print("Error at TimerViewController.loadTrack(): invalid track index \(index), track count - \(tracks.count)")
            return
        }
        let track = tracks[index]
        onLoadTrack?(track)
        let url = track.fileURL
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            onPlayerCreated?(audioPlayer!)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading track: \(error.localizedDescription)")
        }
    }
    
    private func startNextPhase() {
        if currentCount < timerCellModel.count {
            let currentCellModel = timerCellModel[currentCount]
            if currentCellModel.type == .work || currentCellModel.type == .rest {
                let time = Int(currentCellModel.time) ?? 0
                remainingTime = time
                onUpdateTimerLabel?(remainingTime, timerCellModel[currentCount].color)
                onStartAnimation?(remainingTime)
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
            onUpdateTableView?(currentCount, currentTimerCellModel)
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
    
    @objc private func timerTick() {
        if remainingTime > 0 {
            remainingTime -= 1
            onUpdateTimerLabel?(remainingTime, timerCellModel[currentCount].color)
        }
        if remainingTime == 0 {
            advanceToNextPhase()
        }
    }
    
    func activateAudio() {
        loadTrack(at: currentTrackIndex)
        startPlaying()
    }
    
    func startPlaying() {
        audioPlayer?.play()
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
    }
    
    func toggleShuffle() {
        isShuffling.toggle()
        if isShuffling == true && isRepeating == true {
            isRepeating = false
            onUpdateIsRepeatingButtonAppearence?(isRepeating)
        }
        onUpdateIsShufflingButtonAppearence?(isShuffling)
    }
    
    func toggleRepeat() {
        isRepeating.toggle()
        if isShuffling == true && isRepeating == true {
            isShuffling = false
            onUpdateIsShufflingButtonAppearence?(isShuffling)
        }
        onUpdateIsRepeatingButtonAppearence?(isRepeating)
    }
    
    func startIdlePhase() {
        remainingTime = idleDuration
        onUpdateTimerLabel?(remainingTime, .red)
        onStartAnimation?(remainingTime)
        startTimer()
    }
    
    func playNextTrack() {
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
    
    func playPause() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            isPlaying = true
            startPlaying()
        }
        onUpdateIsPlayingButtonAppearence?(isPlaying)
    }
    
    func playPreviousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + tracks.count) % tracks.count
        loadTrack(at: currentTrackIndex)
        startPlaying()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
