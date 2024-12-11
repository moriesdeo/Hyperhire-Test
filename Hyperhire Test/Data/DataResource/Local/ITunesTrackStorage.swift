//
//  ITunesTrackStorage.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import Foundation
import Combine

class ITunesTrackStorage: ITunesTrackRepository {
    private let userDefaultsKey = "iTunesTracks"

    func save(tracks: [ITunesTrackLocal]) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(tracks)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("Error encoding tracks: \(error)")
        }
    }

    func load() -> [ITunesTrackLocal] {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return [] }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([ITunesTrackLocal].self, from: savedData)
        } catch {
            print("Error decoding tracks: \(error)")
            return []
        }
    }

    func saveTrack(track: ITunesTrackLocal) {
        var allTracks = load()
        if let index = allTracks.firstIndex(where: { $0.id == track.id && $0.group == track.group }) {
            allTracks[index] = track
        } else {
            allTracks.append(track)
        }
        save(tracks: allTracks)
        print("Track \(track.trackName) saved to group \(track.group).")
    }

    func saveGroup(tracks: [ITunesTrackLocal], group: String) {
        let allTracks = load()
        let filteredTracks = allTracks.filter { $0.group != group }
        let updatedTracks = filteredTracks + tracks
        save(tracks: updatedTracks)
    }

    func loadGroup(_ group: String) -> [ITunesTrackLocal] {
        return load().filter { $0.group == group }
    }

    func deleteGroup(_ group: String) {
        let allTracks = load()
        let updatedTracks = allTracks.filter { $0.group != group }
        save(tracks: updatedTracks)
        print("All tracks in group \(group) have been deleted.")
    }

    func loadAllGroups() -> [String] {
        return Array(Set(load().map { $0.group })).sorted()
    }
}

