//
//  CustomTabView.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab: String
    private let tabs: [String]
    private let onTabClick: (Int, String) -> Void

    init(
        tabs: [String],
        initialTab: String,
        onTabClick: @escaping (Int, String) -> Void
    ) {
        self.tabs = tabs
        self._selectedTab = State(initialValue: initialTab)
        self.onTabClick = onTabClick
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    TabButton(title: tab, isSelected: selectedTab == tab) {
                        selectedTab = tab
                        onTabClick(index, tab)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}


struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.white : Color.gray, lineWidth: 1)
                        .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
                )
        }
    }
}
