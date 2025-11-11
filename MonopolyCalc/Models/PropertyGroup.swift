import Foundation
import SwiftData

@Model
final class PropertyGroup {
    @Attribute(.unique) var id: String
    var name: String

    init(name: String) {
        self.id = name
        self.name = name
    }
}
