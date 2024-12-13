//
//  DetailViewModel.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import Combine
import Foundation

class DetailViewModel: ObservableObject {
    @Published private(set) var state = SearchState()
    private let storage = ITunesTrackStorage()
    private let service: ITunesService
    private var cancellables = Set<AnyCancellable>()

    init(service: ITunesService = ITunesService()) {
        self.service = service
    }

    func dispatch(_ intent: SearchIntent) {
        switch intent {
        case .updateSearchText(let text):
            state.searchText = text

        case .startSearch:
            guard !state.searchText.isEmpty else {
                dispatch(.showError("Search text cannot be empty"))
                return
            }
            state.isSearching = true
            performSearch(term: state.searchText)

        case .cancelSearch:
            state.searchText = ""
            state.isSearching = false

        case .showToast(let message):
            state.toastMessage = message
            state.showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dispatch(.hideToast)
            }

        case .hideToast:
            state.showToast = false

        case .loadTracks(let tracks):
            state.items = tracks

        case .showError(let message):
            state.errorMessage = message

        case .saveTrack(let track, let group):
            saveTrackToStorage(track: track, group: group)

        case .loadGroup(let group):
            loadTracksByGroup(group: group)

        case .deleteGroup(let group):
            deleteTracksByGroup(group: group)
        }
    }

    private func performSearch(term: String) {
        service.searchMusic(term: term)
            .map { $0.compactMap { $0.toLocal(group: "Search") } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.dispatch(.showError("Error: \(error.localizedDescription)"))
                }
                self?.state.isSearching = false
            }, receiveValue: { [weak self] tracks in
                self?.dispatch(.loadTracks(tracks))
            })
            .store(in: &cancellables)
    }

    private func saveTrackToStorage(track: ITunesTrackLocal, group: String) {
        var updatedTrack = track
        updatedTrack.group = group
        storage.saveTrack(track: updatedTrack)
        dispatch(.showToast("Track '\(track.trackName)' saved to \(group)!"))
    }

    private func loadTracksByGroup(group: String) {
        let tracks = storage.loadGroup(group)
        state.items = tracks
        print("Loaded \(tracks.count) items for group: \(group)")
    }

    private func deleteTracksByGroup(group: String) {
        storage.deleteGroup(group)
        state.items.removeAll { $0.group == group }
        print("Deleted all items for group: \(group)")
    }
}
