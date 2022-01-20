import Foundation
import OrderedCollections

final class TableRowStateManager<Row: Hashable> {

    private var selectedRows = Set<Row>()
    
    var rowExists: (Row) -> Bool = { _ in return false }
    
    var selectedRow: Row? {
        selectedRows.first
    }
    
    func isSelected(_ row: Row) -> Bool {
        selectedRows.contains(row)
    }
    
    func update(_ row: Row, isSelected: Bool) {
        switch isSelected {
        case true: selectedRows.insert(row)
        case false: remove(row)
        }
    }
    
    private func remove(_ row: Row) {
        if let index = selectedRows.firstIndex(of: row) {
            selectedRows.remove(at: index)
        }
    }
    
    func clean() {
        for row in selectedRows {
            if rowExists(row) == false {
                remove(row)
            }
        }
    }
}
