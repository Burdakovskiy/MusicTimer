//
//  MainView.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import UIKit

protocol NewTimerButtonAction: AnyObject {
    func newTimerButtonAction()
}

final class MainView: UIView {
    
    public weak var newTimerActionDelegate: NewTimerButtonAction?
    
    private let newTimerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("New Timer", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let templatesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TemplateTableViewCell.self,
                           forCellReuseIdentifier: TemplateTableViewCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let emptyTemplateLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no templates"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public func reloadTemplatesTableView() {
        templatesTableView.reloadData()
    }
    
    public func deleteTemplate(at indexPath: IndexPath) {
        templatesTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    public func isHideEmptyLabel(_ isHide: Bool) {
        emptyTemplateLabel.isHidden = isHide
    }
    
    public func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        templatesTableView.delegate = delegate
    }
    
    public func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        templatesTableView.dataSource = dataSource
    }
    
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
        addSubview(newTimerButton)
        addSubview(separatorView)
        addSubview(templatesTableView)
        addSubview(emptyTemplateLabel)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            newTimerButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            newTimerButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 32),
            newTimerButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            newTimerButton.heightAnchor.constraint(equalToConstant: 50),
            
            separatorView.topAnchor.constraint(equalTo: newTimerButton.bottomAnchor, constant: 16),
            separatorView.leftAnchor.constraint(equalTo: self.leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            templatesTableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            templatesTableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            templatesTableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            templatesTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            emptyTemplateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyTemplateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func addActions() {
        newTimerButton.addTarget(self,
                                 action: #selector(newTimerButtonPressed),
                                 for: .touchUpInside)
    }
    
    @objc private func newTimerButtonPressed() {
        newTimerActionDelegate?.newTimerButtonAction()
    }
}
