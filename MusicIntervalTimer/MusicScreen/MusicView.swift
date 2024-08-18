//
//  MusicView.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

final class MusicView: UIView {
    
//MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Properties
    
    private let tracksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MusicTableViewCell.self,
                           forCellReuseIdentifier: MusicTableViewCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
//MARK: - Functions
    
    private func addViews() {
        addSubview(tracksTableView)
    }
    
    func reloadTracksTableView() {
        tracksTableView.reloadData()
    }
    
    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tracksTableView.delegate = delegate
    }
    
    func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tracksTableView.dataSource = dataSource
    }
}

//MARK: - setConstraints
private extension MusicView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            tracksTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tracksTableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            tracksTableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            tracksTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
