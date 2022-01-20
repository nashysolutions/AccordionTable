import Foundation
import OrderedCollections

// If your user interface is reloading more rows / sections
// than it should, then it is likely the hashable implementation
// to blame.

// It seems each row must be unique within the entire dataset (not
// just within the section it belongs). Use GUID's on your dataset.

// Alternatively, at the row level make a reference to the section
// in which that row belongs (be careful of retain cycle) and use
// that in the hashable implementation of the row.

// Identifiers not needed in this example because we know with
// certainty that each will be unique.

struct Food: Hashable {
    let title: String
    let items: [Item]
}

struct Item: Hashable {
    let title: String
}

typealias Collection = OrderedDictionary<Food, [Item]>
