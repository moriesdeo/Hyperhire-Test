//
//  DetailViewPage.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = DetailViewModel()
    @State private var isShowingSearchView = false
    let group: String

    var body: some View {
        VStack(spacing: 0) {
            headerView()
            listView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            viewModel.loadItems(byGroup: group)
        }
        .sheet(isPresented: $isShowingSearchView) {
            SearchViewPage(group: group)
        }
    }

    private func headerView() -> some View {
        HStack {
            backButton()
            Spacer()
            addButton()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }

    private func backButton() -> some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.backward")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private func addButton() -> some View {
        Button(action: {
            isShowingSearchView = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private func listView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.items) { track in
                    HStack {
                        thumbnailView(for: track.artworkUrl100)
                        trackInfoView(track: track)
                        Spacer()
                        moreOptionsButton(track: track)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                }
            }
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(group: "Test")
    }
}
