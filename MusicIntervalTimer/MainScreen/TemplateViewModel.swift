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
        self.timerTemplates = TemplateStorage.getTemplates()
        didUpdateTemplates?()
    }
    
    public func saveTemplate(_ template: TemplateModel) {
        TemplateStorage.saveTemplate(template)
        loadTemplates()
    }
    
    public func deleteTemplate(with id: UUID) {
        TemplateStorage.deleteTemplate(with: id)
    }
    
    //TODO: func updateTemplate(with id: UUID)
}
