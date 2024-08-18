//
//  MainViewModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import UIKit

final class TemplateViewModel {
    
//MARK: - Properties
    
    private var timerTemplates = [TemplateModel]()
    var didUpdateTemplates: (() -> Void)?
    
//MARK: - Functions
    
    func getTemplates() -> [TemplateModel] {
        return timerTemplates
    }

    func loadTemplates() {
        self.timerTemplates = TemplateStorage.getTemplates()
        didUpdateTemplates?()
    }
    
    func saveTemplate(_ template: TemplateModel) {
        TemplateStorage.saveTemplate(template)
        loadTemplates()
    }
    
    func deleteTemplate(with id: UUID) {
        TemplateStorage.deleteTemplate(with: id)
    }
    //TODO: func updateTemplate(with id: UUID)
}
