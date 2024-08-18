//
//  TemplateStorage.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 11.08.2024.
//

import Foundation
import UIKit

final class TemplateStorage {
    private static let templatesKey = "savedTemplates"
    
    static func saveTemplate(_ template: TemplateModel) {
        var templates = getTemplates()
        templates.append(template)
        if let data = try? JSONEncoder().encode(templates) {
            UserDefaults.standard.set(data, forKey: templatesKey)
        }
    }
    
    static func getTemplates() -> [TemplateModel] {
        guard let data = UserDefaults.standard.data(forKey: templatesKey),
              let templates = try? JSONDecoder().decode([TemplateModel].self, from: data) else {
            print("Error while getting templates in TemplateStorage.getTemplates() or templates is Empty")
            return []
        }
        return templates
    }
    
    static func deleteTemplate(with id: UUID)  {
        var templates = getTemplates()
        templates.removeAll { template in
            template.timer.id == id
        }
        if let data = try? JSONEncoder().encode(templates) {
            UserDefaults.standard.set(data, forKey: templatesKey)
        }
    }
}
