//
//  YourLibraryViewModel.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import Foundation
import Combine

class YourLibraryViewModel: ObservableObject {
    @Published var playlists: [ITunesTrackAPI] = []
    @Published var selectedTracks: [ITunesTrackAPI] = []
    @Published var groups: [String] = []
    @Published var groupedItems: [ITunesTrackAPI] = []
    @Published var groupSummaries: [GroupSummary] = []
    @Published var items: [ITunesTrackLocal] = []
    @Published var selectedGroup: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let repository: ITunesTrackRepository
    
    init(repository: ITunesTrackRepository = ITunesTrackStorage()) {
        self.repository = repository
    }
    
    func saveSelectedTracks(group: String) {
        let localTracks = selectedTracks.map { $0.toLocal(group: group) }
        repository.saveGroup(tracks: localTracks, group: group)
    }
    
    func loadSelectedTracks() {
        let localTracks = repository.loadGroup("selected")
        selectedTracks = localTracks.map { $0.toAPI() }
    }
    
    func toggleSelection(for track: ITunesTrackAPI) {
        if let index = selectedTracks.firstIndex(where: { $0.id == track.id }) {
            selectedTracks.remove(at: index)
        } else {
            selectedTracks.append(track)
        }
    }
    
    func getGroups() -> [String] {
        return repository.loadAllGroups()
    }
    
    func getItems(byGroup group: String) -> [ITunesTrackAPI] {
        let localTracks = repository.loadGroup(group)
        return localTracks.map { $0.toAPI() }
    }
    
    func loadItems() {
        items = [
            ITunesTrackLocal(
                id: 1,
                artistName: "Artist A",
                trackName: "Track A",
                collectionName: "Album A",
                artworkUrl100: "https://example.com/image.jpg",
                trackPrice: 1.99,
                currency: "USD",
                primaryGenreName: "Pop",
                group: "Favorites"
            )
        ]
    }
    
    func fetchGroupSummaries() {
        let localTracks = repository.load()
        let grouped = Dictionary(grouping: localTracks, by: { $0.group })
        
        groupSummaries = grouped.map { (groupName, items) in
            let images = items.prefix(4).compactMap { $0.artworkUrl100 }
            return GroupSummary(
                groupName: groupName,
                itemCount: items.count,
                previewImages: images
            )
        }
    }
    
    func navigateToGroup(group: String) {
        selectedGroup = group
    }
}
