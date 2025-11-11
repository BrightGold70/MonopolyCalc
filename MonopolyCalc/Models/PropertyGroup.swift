import Foundation

enum PropertyGroup: String, CaseIterable, Identifiable {
    case group1, group2, group3, group4, group5, group6, group7, group8, group9, group10

    var id: String { self.rawValue }
}
