//
//  DetailViewModel.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    private let storage = ITunesTrackStorage()

    @Published var playlists: [ITunesTrackAPI] = []
    @Published var items: [ITunesTrackLocal] = []
    @Published var errorMessage: String? = nil

    private let service: ITunesService
    private var cancellables = Set<AnyCancellable>()

    init(service: ITunesService = ITunesService()) {
        self.service = service
    }

    func searchMusic(term: String) {
        service.searchMusic(term: term)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.logResponse(response)
            })
            .map { $0.compactMap { $0.toLocal(group: "Search") } }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.handleCompletion(completion)
            }, receiveValue: { [weak self] tracks in
                self?.items = tracks
                print("Received \(tracks.count) valid tracks.")
            })
            .store(in: &cancellables)
    }

    func loadItems(byGroup group: String) {
        items = storage.loadGroup(group)
        print("Loaded \(items.count) items for group: \(group)")
    }

    private func logResponse(_ response: [ITunesTrackAPI]) {
        do {
            let jsonData = try JSONEncoder().encode(response)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("API Response JSON: \(jsonString)")
            }
        } catch {
            print("Failed to log API response: \(error.localizedDescription)")
        }
    }

    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Search completed successfully.")
        case .failure(let error):
            print("Error fetching music: \(error.localizedDescription)")
            errorMessage = "Failed to fetch music: \(error.localizedDescription)"
        }
    }
}
