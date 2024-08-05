//
//  MusicViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

class MusicViewController: UIViewController {
    
    private let musicView = MusicView(frame: .zero)
    
    override func loadView() {
        super.loadView()
        view = musicView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        title = "Music"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelButtonPressed))
    }
    
    @objc private func doneButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}
