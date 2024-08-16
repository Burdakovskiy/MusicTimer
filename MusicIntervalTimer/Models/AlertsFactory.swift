//
//  AlertsFactory.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 12.08.2024.
//

import UIKit

final class AlertsFactory {
    
    enum AlertType {
        case okAlert(title: String,
                     message: String?)
        case TFAlert(title: String,
                     message: String?,
                     placeholder: String?,
                     handler: ((String) -> Void)?)
        case errorAlert(description: String)
        
    }
    
    func makeAlert(of type: AlertType) -> UIAlertController {
        switch type {
        case .okAlert(let title, let message):
            makeOkAlert(title: title, message: message)
        case .TFAlert(let title, let message, let placeholder, let handler):
            makeTFAlert(title: title, message: message, placeholder: placeholder, handler: handler)
        case .errorAlert(let description):
            makeErrorAlert(description: description)
        }
    }
    
    private func makeOkAlert(title: String, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        return alert
    }
    
    private func makeTFAlert(title: String, message: String?, placeholder: String?, handler: ((String) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = placeholder
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let text = alert.textFields?[0].text else { return }
            handler?(text)
        }
        alert.addAction(okAction)
        
        return alert
    }
    
    private func makeErrorAlert(description: String) -> UIAlertController {
        let alert = UIAlertController(title: "Ooops Error!", message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        return alert
    }
}
