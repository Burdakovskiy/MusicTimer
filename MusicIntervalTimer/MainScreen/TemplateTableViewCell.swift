//
//  TemplateTableViewCell.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import UIKit

final class TemplateTableViewCell: UITableViewCell {
    
//MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Properties
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var workLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private var restLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private var repeatsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()
    
    private var cyclesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private var playButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var repeatsInfoStack = UIStackView(arrangedSubviews: [repeatsLabel, cyclesLabel],
                                            spacing: 10,
                                            axis: .horizontal)
    
    lazy var additionalInfoStack = UIStackView(arrangedSubviews: [workLabel,
                                                                  restLabel,
                                                                  repeatsInfoStack],
                                               spacing: 5,
                                               axis: .vertical)
    
//MARK: - Functions
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(playButton)
        addSubview(additionalInfoStack)
    }
    
    func configure(with template: TemplateModel) {
        nameLabel.text = template.name
        workLabel.text = "Work time: \(template.timer.workTime)"
        restLabel.text = "Rest time: \(template.timer.restTime)"
        repeatsLabel.text = "R: \(template.timer.repeatsCount)"
        cyclesLabel.text = "C: \(template.timer.cyclesCount)"
    }
}

//MARK: - setConstraints
private extension TemplateTableViewCell {
    func setConstraints() {
        
        additionalInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 80),
            playButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -16),
            
            additionalInfoStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            additionalInfoStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            additionalInfoStack.rightAnchor.constraint(equalTo: playButton.leftAnchor, constant: -16),
            additionalInfoStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7)
        ])
    }
}
