//
//  PlayListViewComponent.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 10/12/24.
//

import SwiftUI

struct PlaylistView: View {
    let title: String
    let subtitle: String
    let imageNames: [String]
    
    var body: some View {
        HStack {
            if imageNames.count == 1, let imageName = imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                // Grid of images
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        if imageNames.indices.contains(0) {
                            Image(imageNames[0])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                        }
                        if imageNames.indices.contains(1) {
                            Image(imageNames[1])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                        }
                    }
                    HStack(spacing: 2) {
                        if imageNames.indices.contains(2) {
                            Image(imageNames[2])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                        }
                        if imageNames.indices.contains(3) {
                            Image(imageNames[3])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                        }
                    }
                }
            }
            
            // Text Section
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Color.white)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .padding()
    }
}


// Preview
struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(
            title: "My first library",
            subtitle: "Playlist • 58 songs",
            imageNames: ["ic_profile"]
        )
        .previewLayout(.sizeThatFits)
        .background(Color.black)
    }
}
