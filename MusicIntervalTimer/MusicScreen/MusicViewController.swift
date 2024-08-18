//
//  MusicViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

final class MusicViewController: UIViewController {
    
//MARK: - Properties
    
    private let musicView = MusicView(frame: .zero)
    private let musicViewModel = MusicViewModel()

    var onTracksSelected: (([Track]) -> Void)?
    
//MARK: - Functions
    
    private func setupDelegates() {
        musicView.setTableViewDelegate(self)
        musicView.setTableViewDataSource(self)
    }
    
    private func bindViewModel() {
        musicViewModel.onTrackUpdated = {[weak self] in
            guard let self else { return }
            musicView.reloadTracksTableView()
        }
    }
    
    private func setupNavigationBar() {
        title = "Tracks"
        navigationItem.hidesBackButton = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed))
        let addButton =  UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(addTrackPressed))
        navigationItem.rightBarButtonItems = [doneButton, addButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonPressed))
    }

    @objc private func addTrackPressed() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio],
                                                            asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        present(documentPicker, animated: true)
    }
    
    @objc private func doneButtonPressed() {
        onTracksSelected?(musicViewModel.tracks)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    override func loadView() {
        super.loadView()
        view = musicView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegates()
        bindViewModel()
    }
}

//MARK: - UITableViewDelegate
extension MusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicViewModel.numberOfTracks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.cellId, for: indexPath) as! MusicTableViewCell
        let track = musicViewModel.track(at: indexPath.row)
        cell.configure(with: track)
        return cell
    }
}

//MARK: - UIDocumentPickerDelegate
extension MusicViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            musicViewModel.addTrack(from: url)
        }
    }
}
