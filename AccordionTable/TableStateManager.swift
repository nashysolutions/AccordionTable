import UIKit

/// We need this backing store because the diffing API uses snapshots.
final class TableStateManager<Section: Hashable, Row: Hashable> {

    var rows: (Section) -> [Row] = { _ in return [] }
    
    private let sectionStateManager = TableSectionStateManager<Section>()
    
    var sectionExists: (Section) -> Bool {
        get {
            sectionStateManager.sectionExists
        }
        set {
            sectionStateManager.sectionExists = newValue
        }
    }

    func visibility(of section: Section) -> SectionVisibility {
        sectionStateManager.visibility(of: section)
    }

    func toggleVisibility(of section: Section) {
        switch visibility(of: section) {
        case .collapsed:
            sectionStateManager.update(section, visibility: .expanded)
        case .expanded:
            sectionStateManager.update(section, visibility: .collapsed)
        }
    }
    
    private let rowStateManager = TableRowStateManager<Row>()
    
    var rowExists: (Row) -> Bool {
        get {
            rowStateManager.rowExists
        }
        set {
            rowStateManager.rowExists = newValue
        }
    }
    
    var selectedRow: Row? {
        rowStateManager.selectedRow
    }
    
    func saveSelectedState(for row: Row) {
        rowStateManager.update(row, isSelected: true)
    }
    
    func saveDeselectedState(for row: Row) {
        rowStateManager.update(row, isSelected: false)
    }

    /// The selected state of the row.
    /// - Parameter row: The row in question.
    /// - Returns: True if the row is in a selected state.
    func selectedState(of row: Row) -> Bool {
        rowStateManager.isSelected(row)
    }

    /// Change the current state of the row.
    /// - Parameter row: The row in question.
    /// - Returns: The state of the row after the change. True if the row is in a selected state.
    func toggleSelectedState(of row: Row) -> Bool {
        
        switch rowStateManager.isSelected(row) {
        case true:
            saveDeselectedState(for: row)
        case false:
            
            // When a row is selected in single selection mode the table view will manage deselection
            // of the other selected cell (if there is one) for us. We listen for deselection events
            // in the table view delegate and update our state manager from there. So we only have to worry
            // about updating our state manager for this row.
            
            saveSelectedState(for: row)

            // Unless...
            // ...the previously selected cell was within a section that has since collapsed. In that case
            // the table view delegate will not fire a deselection event and our state manager will be out of
            // sync. So we need to check to see if there are any collapsed sections here and loop through them
            // to check.
            if let hiddenRow = firstSelectedRowInCollapsedSections() {
                saveDeselectedState(for: hiddenRow)
            }
        }
        return rowStateManager.isSelected(row)
    }

    // We only support single selection mode, so we assume there will be a maximum of
    // one selected row.
    private func firstSelectedRowInCollapsedSections() -> Row? {
        for section in sectionStateManager.collapsedSections {
            for row in rows(section) {
                if rowStateManager.isSelected(row) {
                    return row
                }
            }
        }
        return nil
    }
    
    /// Remove all cached data.
    func clean() {
        rowStateManager.clean()
        sectionStateManager.clean()
    }
}
