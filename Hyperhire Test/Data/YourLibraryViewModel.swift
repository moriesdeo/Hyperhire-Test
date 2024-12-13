//
//  YourLibraryViewModel.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import Foundation
import Combine

class YourLibraryViewModel: ObservableObject {
    @Published var state = LibraryState()
    private var cancellables = Set<AnyCancellable>()
    private let repository: ITunesTrackRepository
    
    init(repository: ITunesTrackRepository = ITunesTrackStorage()) {
        self.repository = repository
    }
    
    func dispatch(_ intent: LibraryIntent) {
        switch intent {
        case .saveSelectedTracks(let group):
            saveSelectedTracks(group: group)
        case .loadSelectedTracks:
            loadSelectedTracks()
        case .toggleSelection(let track):
            toggleSelection(for: track)
        case .getGroups:
            getGroups()
        case .getItems(let group):
            getItems(byGroup: group)
        case .loadItems:
            loadItems()
        case .fetchGroupSummaries:
            fetchGroupSummaries()
        case .navigateToGroup(let group):
            state.selectedGroup = group
            state.isDetailViewPresented = true
            navigateToGroup(group: group)
        }
    }
    
    private func saveSelectedTracks(group: String) {
        let localTracks = state.selectedTracks.map { $0.toLocal(group: group) }
        repository.saveGroup(tracks: localTracks, group: group)
        state.selectedTracks.removeAll()
    }
    
    private func loadSelectedTracks() {
        let localTracks = repository.loadGroup("selected")
        state.selectedTracks = localTracks.map { $0.toAPI() }
    }
    
    private func toggleSelection(for track: ITunesTrackAPI) {
        if let index = state.selectedTracks.firstIndex(where: { $0.id == track.id }) {
            state.selectedTracks.remove(at: index)
        } else {
            state.selectedTracks.append(track)
        }
    }
    
    private func getGroups() {
        state.groups = repository.loadAllGroups()
    }
    
    private func getItems(byGroup group: String) {
        let localTracks = repository.loadGroup(group)
        state.groupedItems = localTracks.map { $0.toAPI() }
    }
    
    private func loadItems() {
        state.items = [
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
    
    private func fetchGroupSummaries() {
        let localTracks = repository.load()
        let grouped = Dictionary(grouping: localTracks, by: { $0.group })
        
        state.groupSummaries = grouped.map { (groupName, items) in
            let images = items.prefix(4).compactMap { $0.artworkUrl100 }
            return GroupSummary(
                groupName: groupName,
                itemCount: items.count,
                previewImages: images
            )
        }
    }
    
    private func navigateToGroup(group: String) {
        state.selectedGroup = group
    }
}
