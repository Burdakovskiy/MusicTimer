//
//  TemplateTableViewCell.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import UIKit

final class TemplateTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
}
