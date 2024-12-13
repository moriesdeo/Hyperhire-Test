//
//  SearchViewPage.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import SwiftUI

struct YourLibraryView: View {
    @StateObject private var viewModel = YourLibraryViewModel()
    
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
                    viewModel.dispatch(.fetchGroupSummaries)
                }
                .navigationBarHidden(true)
            }
            
            if viewModel.state.isBottomSheetPresented {
                BottomSheetDialogCustom(
                    isPresented: $viewModel.state.isBottomSheetPresented,
                    items: viewModel.state.bottomSheetItems
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
            
            if viewModel.state.isBottomSheetInput {
                BottomSheet(
                    isPresented: $viewModel.state.isBottomSheetInput,
                    title: "Enter Group Name",
                    buttonText: "Submit",
                    onButtonTap: { text in
                        viewModel.dispatch(.navigateToGroup(group: text))
                        viewModel.state.isBottomSheetInput = false
                    }
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $viewModel.state.isDetailViewPresented) {
            DetailView(group: viewModel.state.selectedGroup)
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
                    viewModel.state.isGridView.toggle()
                }
            }) {
                Image(systemName: viewModel.state.isGridView ? "list.dash" : "square.grid.2x2")
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
            if viewModel.state.isGridView {
                gridView()
            } else {
                listView()
            }
        }
    }
    
    private func presentBottomSheet() {
        let items = [
            BottomSheetItemData(
                icon: Image("ic_playlist"),
                title: "Add Playlist",
                description: "Create a new playlist",
                action: { viewModel.state.isBottomSheetInput = true },
                onDismiss: nil
            )
        ]
        viewModel.state.bottomSheetItems = items
        viewModel.state.isBottomSheetPresented = true
    }
}

extension YourLibraryView {
    private func gridView() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.state.groupSummaries, id: \.groupName) { group in
                    NavigationLink(destination: DetailView(group: group.groupName)) {
                        GroupCard(group: group)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func listView() -> some View {
        List(viewModel.state.groupSummaries, id: \.groupName) { group in
            NavigationLink(destination: DetailView(group: group.groupName)) {
                GroupRow(group: group)
            }
            .listRowBackground(Color.black)
        }
        .listStyle(PlainListStyle())
    }
}

struct GroupCard: View {
    let group: GroupSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageGrid(images: group.previewImages)
                .frame(height: 80)
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

struct GroupRow: View {
    let group: GroupSummary
    
    var body: some View {
        HStack {
            ImageGrid(images: group.previewImages)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
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
}

struct ImageGrid: View {
    let images: [String]
    
    var body: some View {
        let rows = images.chunked(into: 2)
        return VStack(spacing: 2) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack(spacing: 2) {
                    ForEach(rows[rowIndex], id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        } placeholder: {
                            Color.gray
                        }
                    }
                }
            }
        }
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

struct YourLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        YourLibraryView()
    }
}
