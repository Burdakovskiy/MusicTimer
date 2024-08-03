//
//  MainViewModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import UIKit

final class TemplateViewModel {
    
    private var timerTemplates = [TemplateModel]()
    
    public var didUpdateTemplates: (() -> Void)?
    
    public func getTemplates() -> [TemplateModel] {
        return timerTemplates
    }
    
    public func loadTemplates() {
        
        self.timerTemplates = [
            //TODO: get templates from UserDefaults
        ]
        didUpdateTemplates?()
    }
    
    public func deleteTemplate(with id: UUID) {
        
    }
    
    //TODO: func updateTemplate(with id: UUID)
}
