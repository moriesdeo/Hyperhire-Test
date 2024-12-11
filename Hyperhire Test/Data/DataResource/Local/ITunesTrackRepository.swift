//
//  ITunesTrackRepository.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 11/12/24.
//

protocol ITunesTrackRepository {
    func save(tracks: [ITunesTrackLocal])
    func load() -> [ITunesTrackLocal]
    func saveGroup(tracks: [ITunesTrackLocal], group: String)
    func loadGroup(_ group: String) -> [ITunesTrackLocal]
    func loadAllGroups() -> [String]
}
