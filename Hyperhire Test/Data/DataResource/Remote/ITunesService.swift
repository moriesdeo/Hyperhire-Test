//
//  ITunesService.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 11/12/24.
//
import Foundation
import Combine

class ITunesService {
    func searchMusic(term: String, entity: String? = "musicTrack", limit: Int = 25, country: String = "us") -> AnyPublisher<[ITunesTrackAPI], Error> {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&entity=\(entity ?? "")&limit=\(limit)&country=\(country)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .handleEvents(receiveOutput: { data in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString)")
                }
            })
            .decode(type: ITunesResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}
