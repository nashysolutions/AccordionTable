import UIKit
import AccordionTable

class DiffableTableViewController<TableView: UITableView, Section: TableSection, Row: TableRow>: UIViewController {
    
    typealias CellProvider = (UITableView, IndexPath, Row) -> UITableViewCell
    typealias HeaderProvider = (UITableView, Int, Section) -> HeaderView
    
    private let cellProvider: CellProvider
    private let headerProvider: HeaderProvider
    
    let tableView: TableView
    let diffableTableManager: AccordionTable<Section, Row>
    
    private let tableDataSource: UITableViewDiffableDataSource<Section, Row>
    
    init(tableView: TableView, enabledFeatures: [TableFeature] = [.collapsible], cellProvider: @escaping CellProvider, headerProvider: @escaping HeaderProvider) {
        
        let tableDataSource = UITableViewDiffableDataSource<Section, Row>(
            tableView: tableView,
            cellProvider: cellProvider
        )
        
        let diffableTableManager = AccordionTable<Section, Row>(
            dataSource: tableDataSource,
            enabledFeatures: enabledFeatures,
            headerProvider: headerProvider
        )
        
        self.tableDataSource = tableDataSource
        self.diffableTableManager = diffableTableManager
        self.cellProvider = cellProvider
        self.headerProvider = headerProvider
        self.tableView = tableView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedRow: Row? {
        diffableTableManager.selectedRow
    }
    
    func indexPath(for row: Row) -> IndexPath? {
        tableDataSource.indexPath(for: row)
    }
    
    var indexPathForSelectedRow: IndexPath? {
        if let row = selectedRow {
           return indexPath(for: row)
        }
        return nil
    }

    func selectRow(at indexPath: IndexPath, animated: Bool, scrollPosition: UITableView.ScrollPosition = .top) {
        diffableTableManager.saveSelectedStateForRow(at: indexPath)
        tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }
    
    func deselectSelectedRow(animated: Bool = true) {
        if let indexPath = indexPathForSelectedRow {
            diffableTableManager.saveDeselectedStateForRow(at: indexPath)
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }

    func update(with data: [Section: [Row]], animated: Bool = true, completion: (() -> Void)? = nil) {
        diffableTableManager.update(with: data, animated: animated, completion: completion)
    }
}
