import UIKit

public enum SectionVisibility {
    case collapsed
    case expanded
}

public typealias TableSection = Hashable & Comparable
public typealias TableRow = Hashable & Comparable

/// A wrapper for a diffable dataSource which facilitates collapsible table view sections. Responsible for coordinating cell selection, in
/// single-selection mode only.
/// - Important: The property `allowsMultipleSelection` on `UITableView` must be set to false.
public final class AccordionTable<Section: TableSection, Row: TableRow> {

    public typealias DiffableDataSource = UITableViewDiffableDataSource<Section, Row>
    public typealias HeaderProvider = (UITableView, Int, Section) -> HeaderView

    public let dataSource: DiffableDataSource
    private let headerProvider: HeaderProvider
    private let animationDuration: CGFloat = 0.2
    
    private var data = [Section: [Row]]()
    
    private let stateManager = TableStateManager<Section, Row>()
    
    public init(dataSource: DiffableDataSource, headerProvider: @escaping HeaderProvider) {
        
        self.dataSource = dataSource
        self.headerProvider = headerProvider
                
        self.stateManager.rows = { [unowned self] section in
            self.data[section] ?? []
        }
        
        self.stateManager.sectionExists = { [unowned self] section in
            for (key, _) in self.data {
                if section == key {
                    return true
                }
            }
            return false
        }
        
        self.stateManager.rowExists = { [unowned self] row in
            for (_, value) in self.data {
                if value.contains(row) {
                    return true
                }
            }
            return false
        }
    }
    
    /// The row that is considered to be in a selected state.
    /// The selected state of the table view row should be in sync with this value.
    public var selectedRow: Row? {
        stateManager.selectedRow
    }
    
    /// A means of updating the whole table view with new data. Any matching data will remain in place.
    /// - Parameters:
    ///   - data: A snapshot of data representing the entire content of the table.
    ///   - animated: An indication to animate the table view transition.
    ///   - completion: The block that is executed once the table view animations have completed.
    public func update(with data: [Section: [Row]], animated: Bool = true, completion: (() -> Void)? = nil) {
        self.data = data
        stateManager.clean()
        applySnapshot(animated, completion: completion)
    }

    /// Provides a table view section header. This must be called in the `UITableViewDelegate` method `tableView(viewForHeaderInSection:) -> UIView?`.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - index: The table view section index.
    /// - Returns: A table section header view.
    public func viewForHeader(in tableView: UITableView, at index: Int) -> HeaderView? {
        guard let section = section(for: index) else {
            return nil
        }
        let view = headerProvider(tableView, index, section)
        view.delegate = self
        view.dataSource = self
        view.update(with: section)
        view.reload(animationDuration: 0)
        return view
    }

    /// Updates the selected state of the row. This must be called in the `UITableViewDelegate` method `tableView(willDisplay:forRowAt:)`.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The position of the row.
    public func selectRowIfNeeded(in tableView: UITableView, at indexPath: IndexPath, animated: Bool = false) {
        if let row = dataSource.itemIdentifier(for: indexPath), stateManager.selectedState(of: row) {
            tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
        }
    }
    
    /// Change the current state of the row.
    /// - Parameter indexPath: The position of the row.
    /// - Returns: The state of the row after the change. True if the row is in a selected state.
    public func toggleSelectedStateForRow(at indexPath: IndexPath) -> Bool? {
        guard let row = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        return stateManager.toggleSelectedState(of: row)
    }
    
    /// Stores an indication that the row is in a selected state. The store is not serialised to disk.
    /// The selected state of the table view row should be in sync with this value.
    /// - Parameter indexPath: The position of the row.
    public func saveSelectedStateForRow(at indexPath: IndexPath) {
        if let row = dataSource.itemIdentifier(for: indexPath) {
            stateManager.saveSelectedState(for: row)
        }
    }
    
    /// Stores an indication that the row is in a deselected state. The store is not serialised to disk.
    /// The deselected state of the table view row should be in sync with this value.
    /// - Parameter indexPath: The position of the row.
    public func saveDeselectedStateForRow(at indexPath: IndexPath) {
        if let row = dataSource.itemIdentifier(for: indexPath) {
            stateManager.saveDeselectedState(for: row)
        }
    }
    
    private func applySnapshot(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        let snapshot = makeSnapshot()
        dataSource.apply(snapshot, animatingDifferences: animated, completion: completion)
    }

    private func makeSnapshot() -> NSDiffableDataSourceSnapshot<Section, Row> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections(data.keys.sorted())
        for (section, rows) in data {
            switch stateManager.visibility(of: section) {
            case .collapsed:
                continue
            case .expanded:
                snapshot.appendItems(rows, toSection: section)
            }
        }
        return snapshot
    }
    
    private func section(for sectionIndex: Int) -> Section? {
        if #available(iOS 15.0, *) {
            return dataSource.sectionIdentifier(for: sectionIndex)
        }
        return data.keys.sorted()[sectionIndex]
    }
}

extension AccordionTable: HeaderDataSource {
    
    public func headerView(_ headerView: HeaderView, rowVisibility section: Any?) -> SectionVisibility {
        guard let section = section as? Section else {
            return .expanded
        }
        return stateManager.visibility(of: section)
    }
}

extension AccordionTable: HeaderDelegate {
    
    public func headerView(_ headerView: HeaderView, didDetectTouch section: Any?) {
        
        guard let section = section as? Section else {
            return
        }
        
        stateManager.toggleVisibility(of: section)
        
        /// Both the animation of the header view and the animation of the
        /// table rows are independent, but timed well enough to appear in unison.
        let animated = true
        headerView.reload(animationDuration: animationDuration)
        applySnapshot(animated)
    }
}
