//
//  SetupTimerView.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

protocol ButtonActions: AnyObject {
    func startNextButtonAction()
    func addMusicButtonAction()
}

final class SetupTimerView: UIView {
    private let startNextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addMusicButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("Add music", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var buttonActionsDelegate: ButtonActions?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        setConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(startNextButton)
        addSubview(addMusicButton)
    }
    
    private func addActions() {
        startNextButton.addTarget(self,
                                  action: #selector(startNextButtonPressed),
                                  for: .touchUpInside)
        addMusicButton.addTarget(self,
                                 action: #selector(addMusicButtonPressed),
                                 for: .touchUpInside)
    }
    
    @objc private func startNextButtonPressed() {
        buttonActionsDelegate?.startNextButtonAction()
    }
    
    @objc private func addMusicButtonPressed() {
        buttonActionsDelegate?.addMusicButtonAction()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            startNextButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            startNextButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 32),
            startNextButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            startNextButton.heightAnchor.constraint(equalToConstant: 50),
            
            addMusicButton.bottomAnchor.constraint(equalTo: startNextButton.topAnchor, constant: -16),
            addMusicButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 32),
            addMusicButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            addMusicButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
