//
//  ApiService.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import Foundation
import Combine

struct ITunesResponse: Decodable {
    let resultCount: Int
    let results: [ITunesTrackAPI]
}

struct ITunesTrackAPI: Identifiable, Codable {
    let id: Int
    let artistName: String
    let trackName: String
    let collectionName: String?
    let artworkUrl100: String?
    let trackPrice: Double?
    let currency: String?
    let primaryGenreName: String?
    let previewUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case artistName, trackName, collectionName
        case artworkUrl100, trackPrice, currency
        case primaryGenreName, previewUrl
    }

    func toLocal(group: String) -> ITunesTrackLocal {
        ITunesTrackLocal(
            id: id,
            artistName: artistName,
            trackName: trackName,
            collectionName: collectionName ?? "Unknown Collection",
            artworkUrl100: artworkUrl100 ?? "",
            trackPrice: trackPrice ?? 0.0,
            currency: currency ?? "USD",
            primaryGenreName: primaryGenreName ?? "Unknown Genre",
            group: group
        )
    }
}
