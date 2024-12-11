//
//  ITunesTrackStorage.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import Foundation

struct ITunesTrackStorage {
    private let userDefaultsKey = "iTunesTracks"

    func save(_ tracks: [ITunesTrackLocal]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tracks) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    func load() -> [ITunesTrackLocal] {
        guard let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([ITunesTrackLocal].self, from: savedData)) ?? []
    }

    func saveGroup(_ tracks: [ITunesTrackLocal], group: String) {
        let allTracks = load()
        let filteredTracks = allTracks.filter { $0.group != group }
        let updatedTracks = filteredTracks + tracks
        save(updatedTracks)
    }

    func loadGroup(_ group: String) -> [ITunesTrackLocal] {
        load().filter { $0.group == group }
    }

    func loadAllGroups() -> [String] {
        let allTracks = load()
        return Array(Set(allTracks.map { $0.group })).sorted()
    }
}
