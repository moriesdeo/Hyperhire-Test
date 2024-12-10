//
//  SearchViewPage.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import SwiftUI

struct YourLibraryView: View {
    @State private var selectedTab: String = "Playlists"
    @State private var isBottomSheetPresented: Bool = false
    @State private var isBottomSheetInput: Bool = false
    @State private var customTabs: [String] = []
    @State private var playlists: [Playlist] = [
        Playlist(title: "My first library", subtitle: "Playlist • 58 songs", images: ["ic_profile"]),
        Playlist(title: "Chill Vibes", subtitle: "Playlist • 20 songs", images: ["ic_profile"]),
        Playlist(title: "Workout Mix", subtitle: "Playlist • 35 songs", images: ["ic_profile"])
    ]
    @State private var tabs: [String] = ["Playlist"]
    @State private var isGridView: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
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
                
                Button(action: {
                    withAnimation {
                        isBottomSheetPresented = true
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.black)
            
            CustomTabView(
                tabs: tabs,
                initialTab: selectedTab,
                onTabClick: { index, tab in
                    selectedTab = tab
                    print("Selected Tab: \(tab) at index \(index)")
                }
            ).background(Color.white)
            
            HStack {
                HStack {
                    Image("ic_sort")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
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
                    Image(isGridView ? "ic_list" : "ic_grid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            .padding()
            
            if isGridView {
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(playlists) { playlist in
                            PlaylistView(
                                title: playlist.title,
                                subtitle: playlist.subtitle,
                                imageNames: playlist.images
                            )
                            .onTapGesture {
                                print("Tapped on playlist: \(playlist.title)")
                            }
                            .background(Color.black)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            } else {
                List {
                    ForEach(playlists) { playlist in
                        PlaylistView(
                            title: playlist.title,
                            subtitle: playlist.subtitle,
                            imageNames: playlist.images
                        )
                        .onTapGesture {
                            print("Tapped on playlist: \(playlist.title)")
                        }
                        .listRowBackground(Color.black)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.black)
            }
            
            if isBottomSheetPresented {
                BottomSheetDialogCustom(
                    isPresented: $isBottomSheetPresented,
                    items: [
                        BottomSheetItemData(
                            icon: Image("ic_playlist"),
                            title: "Playlist",
                            description: "Create a playlist with a song",
                            action: {
                                isBottomSheetInput = true
                            },
                            onDismiss: {}
                        ),
                    ]
                )
            }
            if isBottomSheetInput {
                BottomSheet(
                    isPresented: $isBottomSheetInput,
                    title: "Name your playlist",
                    buttonText: "Confirm",
                    onButtonTap: { newTab in
                        if !newTab.isEmpty {
                            withAnimation {
                                customTabs.append(newTab)
                                selectedTab = newTab
                            }
                        }
                    }
                )
            }
        }
        .onChange(of: selectedTab) {
            if !selectedTab.isEmpty && !tabs.contains(selectedTab) {
                withAnimation {
                    tabs.append(selectedTab)
                }
            }
        }
        .background(Color.black)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }
}



// Playlist model for sample data
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
