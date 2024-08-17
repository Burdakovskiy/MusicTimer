//
//  TrackTableViewCell.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 12.08.2024.
//

import Foundation
import UIKit

final class MusicTableViewCell: UITableViewCell {
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with track: Track) {
        nameLabel.text = track.title
    }
    
    private func setupViews() {
        addSubview(nameLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32)
        ])
    }
}
