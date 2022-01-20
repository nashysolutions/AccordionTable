import Foundation
import OrderedCollections

// Identifiers not needed here as we are in complete control of the data, which is deliberately unique.
struct Food: Hashable {
    let title: String
    let items: [Item]
}

struct Item: Hashable {
    let title: String
}

typealias Collection = OrderedDictionary<Food, [Item]>
