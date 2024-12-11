//
//  SearchViewPage.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 11/12/24.
//

import SwiftUI

struct SearchViewPage: View {
    let group: String
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = DetailViewModel()
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            searchBar()
            listView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            print("Group received: \(group)")
        }
    }
    
    private func searchBar() -> some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 10)
            }
            
            TextField("Search music...", text: $searchText, onEditingChanged: { isEditing in
                isSearching = isEditing
            })
            .padding(10)
            .background(Color(.systemGray5))
            .cornerRadius(8)
            .padding(.trailing)
            
            if isSearching {
                Button(action: {
                    searchText = ""
                    isSearching = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding(.trailing, 8)
                }
            }
        }
        .onSubmit {
            viewModel.searchMusic(term: searchText)
        }
        .padding(.vertical)
        .background(Color.black)
    }
    
    private func listView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.items, id: \.id) { track in
                    HStack {
                        thumbnailView(for: track.artworkUrl100 ?? "")
                        trackInfoView(track: track)
                        Spacer()
                        saveButton(for: track)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                }
            }
        }
    }
    
    private func saveButton(for track: ITunesTrackLocal) -> some View {
        Button(action: {
            viewModel.saveTrack(track: track, toGroup: group)
        }) {
            Image(systemName: "tray.and.arrow.down")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
    }
    
    private func thumbnailView(for url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        } placeholder: {
            Color.gray.frame(width: 50, height: 50)
        }
    }
    
    private func trackInfoView(track: ITunesTrackLocal) -> some View {
        VStack(alignment: .leading) {
            Text(track.trackName)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(track.artistName)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }
    
    private func moreOptionsButton(track: ITunesTrackLocal) -> some View {
        Button(action: {
            print("More options tapped for \(track.trackName)")
        }) {
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
    }
}

struct SearchViewPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewPage(group: "test")
    }
}
