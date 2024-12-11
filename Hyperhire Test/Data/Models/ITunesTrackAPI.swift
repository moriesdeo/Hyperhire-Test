//
//  ApiService.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

struct ITunesTrackAPI: Identifiable, Decodable {
    let id: Int
    let artistName: String
    let trackName: String
    let collectionName: String?
    let artworkUrl100: String
    let trackViewUrl: String
    let previewUrl: String?
    let trackPrice: Double?
    let currency: String
    let primaryGenreName: String

    private enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case artistName
        case trackName
        case collectionName
        case artworkUrl100
        case trackViewUrl
        case previewUrl
        case trackPrice
        case currency
        case primaryGenreName
    }
}

extension ITunesTrackAPI {
    func toLocal(group: String) -> ITunesTrackLocal {
        return ITunesTrackLocal(
            id: id,
            artistName: artistName,
            trackName: trackName,
            collectionName: collectionName,
            artworkUrl100: artworkUrl100,
            trackPrice: trackPrice,
            currency: currency,
            primaryGenreName: primaryGenreName,
            group: group
        )
    }
}
