//
//  MusicViewController.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit
import AVFoundation

final class MusicViewController: UIViewController {
    
    var onTracksSelected: (([Track]) -> Void)?
    
    private let musicView = MusicView(frame: .zero)
    private let musicViewModel = MusicViewModel()
    
    override func loadView() {
        super.loadView()
        view = musicView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDelegates()
    }
    
    private func setupDelegates() {
        musicView.setTableViewDelegate(self)
        musicView.setTableViewDataSource(self)
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        title = "Tracks"
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
    
    @objc func addTrackPressed() {
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
}

extension MusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicViewModel.numberOfTracks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.cellId, for: indexPath) as! TrackTableViewCell
        let track = musicViewModel.track(at: indexPath.row)
        cell.configure(with: track)
        return cell
    }
}

extension MusicViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            addTrack(from: url)
        }
    }
    
    private func addTrack(from url: URL) {
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("File not available locally: \(url)")
            return
        }
        
        guard url.pathExtension.lowercased() == "mp3" || url.pathExtension.lowercased() == "m4a" else {
            print("Unsupported file format: \(url.pathExtension)")
            return
        }
        let asset = AVAsset(url: url)
        let duration = CMTimeGetSeconds(asset.duration)
        let track = Track(title: url.lastPathComponent, duration: duration, fileURL: url)
        musicViewModel.addTrack(track)
        musicView.reloadTracksTableView()
    }
}
