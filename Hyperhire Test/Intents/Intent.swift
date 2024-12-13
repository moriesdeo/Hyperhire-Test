//
//  Intent.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 12/12/24.
//

import Foundation

enum SearchIntent {
    case updateSearchText(String)
    case startSearch
    case cancelSearch
    case showToast(String)
    case hideToast
    case loadTracks([ITunesTrackLocal])
    case showError(String)
    case saveTrack(ITunesTrackLocal, String)
    case loadGroup(String)
    case deleteGroup(String)
}

enum LibraryIntent {
    case saveSelectedTracks(group: String)
    case loadSelectedTracks
    case toggleSelection(track: ITunesTrackAPI)
    case getGroups
    case getItems(group: String)
    case loadItems
    case fetchGroupSummaries
    case navigateToGroup(group: String)
}
