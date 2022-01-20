import Foundation
import OrderedCollections

struct Food: Hashable {
    let title: String
    let items: [Item]
}

struct Item: Hashable {
    let title: String
}

typealias Collection = OrderedDictionary<Food, [Item]>
