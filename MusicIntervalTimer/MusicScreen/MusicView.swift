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
    }
    
    private let tracksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TrackTableViewCell.self,
                           forCellReuseIdentifier: TrackTableViewCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(tracksTableView)
    }
    
    public func reloadTracksTableView() {
        tracksTableView.reloadData()
    }
    
    public func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tracksTableView.delegate = delegate
    }
    
    public func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tracksTableView.dataSource = dataSource
    }
   
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tracksTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tracksTableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            tracksTableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            tracksTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
