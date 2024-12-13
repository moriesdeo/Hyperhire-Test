//
//  State.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 12/12/24.
//

import Foundation

struct SearchState {
    var searchText: String = ""
    var isSearching: Bool = false
    var showToast: Bool = false
    var toastMessage: String = ""
    var items: [ITunesTrackLocal] = []
    var errorMessage: String? = nil
}

struct LibraryState {
    var playlists: [ITunesTrackAPI] = []
    var selectedTracks: [ITunesTrackAPI] = []
    var groups: [String] = []
    var groupedItems: [ITunesTrackAPI] = []
    var groupSummaries: [GroupSummary] = []
    var items: [ITunesTrackLocal] = []
    var selectedGroup: String = ""
    var isGridView: Bool = false
    var isBottomSheetPresented: Bool = false
    var isBottomSheetInput: Bool = false
    var bottomSheetItems: [BottomSheetItemData] = []
    var isDetailViewPresented: Bool = false
}
