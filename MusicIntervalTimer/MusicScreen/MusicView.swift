//
//  MusicView.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

final class MusicView: UIView {
    
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
    }
    
    private func addActions() {
        
    }
   
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
