//
//  TimerTableViewCell.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 07.08.2024.
//

import UIKit

final class TimerTableViewCell: UITableViewCell {

//MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Properties
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//MARK: - Functions
    
    private func addViews() {
        self.contentView.addSubview(numberLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(timeLabel)
    }
    
    func configure(with model: TimerCellModel, index: Int) {
        numberLabel.text = String(index + 1) + "."
        descriptionLabel.text = model.name
        timeLabel.text = model.time
        backgroundColor = model.color
    }
}

//MARK: - setConstraints
private extension TimerTableViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            numberLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: numberLabel.rightAnchor, constant: 16),
            
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
        ])
    }
}
