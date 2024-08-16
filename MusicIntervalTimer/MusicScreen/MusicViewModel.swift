//
//  MusicViewModel.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import Foundation

final class MusicViewModel {
    private(set) var tracks: [Track] = []
    
    func addTrack(_ track: Track) {
        tracks.append(track)
    }
    
    func track(at index: Int) -> Track {
        return tracks[index]
    }
    
    func numberOfTracks() -> Int {
        return tracks.count
    }
    
    func deleteTrack(at index: Int) {
        tracks.remove(at: index)
    }
}
