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
                tabs: customTabs,
                initialTab: selectedTab,
                onTabClick: { _, label in
                    selectedTab = label
                }
            ) { _ in
                EmptyView()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("This is the \(selectedTab) content")
                        .foregroundColor(.white)
                }
                .padding()
            }
            .background(Color.black)
            
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
                            onDismiss: {
                                
                            }
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
        .background(Color.black)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }
}

struct YourLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        YourLibraryView()
    }
}
