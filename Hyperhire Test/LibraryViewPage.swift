//
//  SearchViewPage.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import SwiftUI

struct YourLibraryView: View {
    @StateObject private var viewModel = YourLibraryViewModel()
    @State private var isGridView: Bool = false
    @State private var isBottomSheetPresented: Bool = false
    @State private var isBottomSheetInput: Bool = false
    @State private var bottomSheetItems: [BottomSheetItemData] = []
    @State private var selectedGroup: String? = nil
    @State private var isDetailViewPresented: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                VStack(spacing: 0) {
                    headerView()
                    sortingBar()
                    contentView()
                }
                .background(Color.black.ignoresSafeArea())
                .onAppear {
                    viewModel.fetchGroupSummaries()
                }
                .navigationBarHidden(true)
            }

            if isBottomSheetPresented {
                BottomSheetDialogCustom(
                    isPresented: $isBottomSheetPresented,
                    items: bottomSheetItems
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }

            if isBottomSheetInput {
                BottomSheet(
                    isPresented: $isBottomSheetInput,
                    title: "Enter Group Name",
                    buttonText: "Submit",
                    onButtonTap: { text in
                        selectedGroup = text
                        isBottomSheetInput = false
                        isDetailViewPresented = true
                    }
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $isDetailViewPresented) {
            if let group = selectedGroup {
                DetailView(group: group)
            }
        }
    }

    private func headerView() -> some View {
        HStack {
            Image("ic_profile")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .padding(.trailing, 8)

            Text("Your Library")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()

            Button(action: presentBottomSheet) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.black)
    }

    private func presentBottomSheet() {
        bottomSheetItems = [
            BottomSheetItemData(
                icon: Image("ic_playlist"),
                title: "Add Playlist",
                description: "Create a new playlist",
                action: { isBottomSheetInput = true },
                onDismiss: nil
            )
        ]
        isBottomSheetPresented = true
    }
}

extension YourLibraryView {
    private func sortingBar() -> some View {
        HStack {
            HStack {
                Image(systemName: "line.3.horizontal.decrease")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                Text("Most recent")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: {
                withAnimation {
                    isGridView.toggle()
                }
            }) {
                Image(systemName: isGridView ? "list.dash" : "square.grid.2x2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }

    private func contentView() -> some View {
        Group {
            if isGridView {
                gridView()
            } else {
                listView()
            }
        }
    }

    private func gridView() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.groupSummaries) { group in
                    NavigationLink(destination: DetailView(group: group.groupName)) {
                        VStack(alignment: .leading, spacing: 8) {
                            imageGrid(for: group.previewImages)
                                .frame(height: 80)
                                .background(Color.black)
                                .cornerRadius(8)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(group.groupName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Playlist • \(group.itemCount) songs")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func listView() -> some View {
        List(viewModel.groupSummaries) { group in
            NavigationLink(destination: DetailView(group: group.groupName)) {
                HStack(alignment: .center) {
                    imageGrid(for: group.previewImages)
                        .frame(width: 80, height: 80)
                        .background(Color.black)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(group.groupName)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Playlist • \(group.itemCount) songs")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 8)

                    Spacer()
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.black)
        }
        .listStyle(PlainListStyle())
    }

    private func imageGrid(for images: [String]) -> some View {
        let rows: [[String]] = Array(images.prefix(4)).chunked(into: 2)
        return VStack(spacing: 2) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                imageRow(for: rows[rowIndex])
            }
        }
    }

    private func imageRow(for row: [String]) -> some View {
        HStack(spacing: 2) {
            ForEach(row, id: \.self) { imageUrl in
                imageCell(for: imageUrl)
            }
        }
    }

    private func imageCell(for imageUrl: String) -> some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        } placeholder: {
            Color.gray
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }

    private func emptyStateView() -> some View {
        VStack {
            Text("No playlists found")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Try searching or adding new tracks.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .multilineTextAlignment(.center)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, self.count)])
            chunks.append(chunk)
        }
        return chunks
    }
}

struct Playlist: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let images: [String]
}

struct YourLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        YourLibraryView()
    }
}
