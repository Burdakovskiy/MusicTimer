//
//  TimerViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

class TimerViewController: UIViewController {

    private let timerView = TimerView(frame: .zero)
    var timer: TimerModel!
    var timerName: String?
    
    override func loadView() {
        super.loadView()
        view = timerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = timerName ?? "Timer"
    }
}
