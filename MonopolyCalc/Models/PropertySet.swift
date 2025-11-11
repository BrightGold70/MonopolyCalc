import Foundation
import SwiftData

@Model
final class PropertySet {
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var properties: [Property]

    init(id: UUID = UUID(), name: String, properties: [Property]) {
        self.id = id
        self.name = name
        self.properties = properties
    }
}

extension PropertySet {
    static var defaultSet: PropertySet {
        PropertySet(name: "Default Set", properties: SampleData.properties)
    }

    static var sampleSets: [PropertySet] {
        [
            .defaultSet,
            PropertySet(name: "My Custom Set 1", properties: []),
            PropertySet(name: "Speedy Monopoly", properties: [])
        ]
    }
}
