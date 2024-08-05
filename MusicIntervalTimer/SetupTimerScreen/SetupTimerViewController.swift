//
//  SetupTimerViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

class SetupTimerViewController: UIViewController {
    
    private let setupView = SetupTimerView(frame: .zero)
    
    override func loadView() {
        super.loadView()
        view = setupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView.buttonActionsDelegate = self
        print("im here")
    }
}

extension SetupTimerViewController: ButtonActions {
    func addMusicButtonAction() {
        let musicVC = MusicViewController()
        navigationController?.pushViewController(musicVC, animated: true)
    }
    
    func startNextButtonAction() {
        let timerVC = TimerViewController()
//        timerVC.modalPresentationStyle = .fullScreen
        present(timerVC, animated: true)
    }
}
