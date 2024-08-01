//
//  MainView.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import UIKit

protocol NewTimerButtonAction: AnyObject {
    func newTimerButtonAction()
}

final class MainView: UIView {
    
    public weak var newTimerActionDelegate: NewTimerButtonAction?
    
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
    
    let newTimerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("New Timer", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let templatesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        tableView.register(TemplateTableViewCell.self,
                           forCellReuseIdentifier: TemplateTableViewCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func addViews() {
        addSubview(newTimerButton)
        addSubview(templatesTableView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            newTimerButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            newTimerButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 32),
            newTimerButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            newTimerButton.heightAnchor.constraint(equalToConstant: 50),
            
            templatesTableView.topAnchor.constraint(equalTo: newTimerButton.bottomAnchor, constant: 16),
            templatesTableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            templatesTableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            templatesTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addActions() {
        newTimerButton.addTarget(self,
                                 action: #selector(newTimerButtonPressed),
                                 for: .touchUpInside)
    }
    
    @objc private func newTimerButtonPressed() {
        newTimerActionDelegate?.newTimerButtonAction()
    }
}
