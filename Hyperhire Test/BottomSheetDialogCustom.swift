//
//  BottomSheetDialogCustom.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import SwiftUI

struct BottomSheet: View {
    @Binding var isPresented: Bool
    let title: String
    let buttonText: String
    let onButtonTap: (String) -> Void
    
    @State private var textInput: String = ""
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }

                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray)
                        .frame(width: 40, height: 6)
                        .padding(.top, 8)
                        .padding(.bottom, 8)

                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 16)
                    
                    TextField("Enter something...", text: $textInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 16)
                    
                    Button(action: {
                        onButtonTap(textInput)
                        withAnimation {
                            isPresented = false
                        }
                    }) {
                        Text(buttonText)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .background(textInput.count > 0 ? Color.blue : Color.gray)
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                    }
                    .disabled(textInput.count == 0)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .background(Color.white)
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
