import Foundation
import AccordionTable

// Identifiers not needed here as we are in complete control of the data, which is deliberately unique.
struct Food: Hashable, Comparable {
    
    static func < (lhs: Food, rhs: Food) -> Bool {
        lhs.title < rhs.title
    }
    
    let title: String
    let items: [Item]
}

struct Item: Hashable, Comparable {
    
    static func < (lhs: Item, rhs: Item) -> Bool {
        lhs.title < rhs.title
    }
    
    let title: String
}

typealias Collection = Dictionary<Food, [Item]>
