//
//  ViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 01.08.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    private lazy var mainView: MainView = .init(frame: .zero)
    private var mainViewModel: TemplateViewModel
    private var templates = [TemplateModel]()
    
    init(mainViewModel: TemplateViewModel) {
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        setupDelegates()
        loadTemplates()
    }
    
    private func loadTemplates() {
        mainViewModel.didUpdateTemplates = {[weak self] in
            guard let self else { return }
            templates = mainViewModel.getTemplates()
            self.mainView.reloadTemplatesTableView()
            mainView.isHideEmptyLabel(!templates.isEmpty)
        }
        mainViewModel.loadTemplates()
    }

    private func setupDelegates() {
        mainView.newTimerActionDelegate = self
        mainView.setTableViewDelegate(self)
        mainView.setTableViewDataSource(self)
    }
}

extension MainViewController: NewTimerButtonAction {
    func newTimerButtonAction() {
        let setupTimerVC = SetupTimerViewController()
        navigationController?.pushViewController(setupTimerVC, animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenTemplate = templates[indexPath.row]
        let timerVC = TimerViewController()
        timerVC.timer = chosenTemplate.timer
        timerVC.timerName = chosenTemplate.name
        navigationController?.pushViewController(timerVC, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TemplateTableViewCell.cellId,
                                                    for: indexPath) as? TemplateTableViewCell {
            let currentTemplate = templates[indexPath.row]
            cell.configure(with: currentTemplate)
            return cell
        }
        return UITableViewCell()
    }
    
    
}
