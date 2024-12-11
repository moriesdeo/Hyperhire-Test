//
//  ITunesTrackLocal.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

struct ITunesTrackLocal: Identifiable, Codable {
    let id: Int
    let artistName: String
    let trackName: String
    let collectionName: String?
    let artworkUrl100: String
    let trackPrice: Double?
    let currency: String
    let primaryGenreName: String
    let group: String
}

extension ITunesTrackLocal {
    func toAPI() -> ITunesTrackAPI {
        return ITunesTrackAPI(
            id: id,
            artistName: artistName,
            trackName: trackName,
            collectionName: collectionName,
            artworkUrl100: artworkUrl100,
            trackPrice: trackPrice,
            currency: currency,
            primaryGenreName: primaryGenreName,
            previewUrl: nil
        )
    }
}
