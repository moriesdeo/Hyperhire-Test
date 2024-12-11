//
//  GroupSummary.swift
//  Hyperhire Test
//
//  Created by Mories Hutapea on 11/12/24.
//
import Foundation

struct GroupSummary: Identifiable {
    let id = UUID()
    let groupName: String
    let itemCount: Int
    let previewImages: [String]
}
