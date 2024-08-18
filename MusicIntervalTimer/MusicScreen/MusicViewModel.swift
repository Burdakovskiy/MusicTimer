//
//  MusicViewModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import Foundation
import AVFoundation

final class MusicViewModel {
    
//MARK: - Properties
    
    private(set) var tracks: [Track] = []
    var onTrackUpdated: (() -> Void)?
    
//MARK: - Functions
    
    func addTrack(_ track: Track) {
        tracks.append(track)
        onTrackUpdated?()
    }
    
    func track(at index: Int) -> Track {
        return tracks[index]
    }
    
    func numberOfTracks() -> Int {
        return tracks.count
    }
    
    func addTrack(from url: URL) {
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
        addTrack(track)
    }
    
    //TODO: DeleteTrack
//    func deleteTrack(at index: Int) {
//        tracks.remove(at: index)
//        onTrackUpdated?()
//    }
}
