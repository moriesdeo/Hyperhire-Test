//
//  BottomSheetIconCustom.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import SwiftUI

struct BottomSheetDialogCustom: View {
    @Binding var isPresented: Bool
    let items: [BottomSheetItemData]

    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                            items.forEach { $0.onDismiss?() }
                        }
                    }

                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray)
                        .frame(width: 40, height: 6)
                        .padding(.top, 8)
                        .padding(.bottom, 8)

                    ForEach(items, id: \.title) { item in
                        BottomSheetItem(
                            icon: item.icon,
                            title: item.title,
                            description: item.description,
                            onTap: {
                                withAnimation {
                                    isPresented = false
                                    item.action()
                                }
                            }
                        )
                    }
                }
                .background(Color.black)
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .offset(y: max(0, offset))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation.height
                        }
                        .onEnded { _ in
                            if offset > 150 {
                                withAnimation {
                                    isPresented = false
                                    items.forEach { $0.onDismiss?() }
                                }
                            } else {
                                withAnimation {
                                    offset = 0
                                }
                            }
                        }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

struct BottomSheetItem: View {
    let icon: Image
    let title: String
    let description: String
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(spacing: 16) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct BottomSheetItemData {
    let icon: Image
    let title: String
    let description: String
    let action: (() -> Void)
    let onDismiss: (() -> Void)?
}
