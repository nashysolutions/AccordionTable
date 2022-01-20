import UIKit

final class FoodsViewController: DiffableTableViewController<FoodTableView, Food, Item> {

    private lazy var delegate = FoodTableViewDelegate(diffableTableManager)

    lazy var data: Collection = try! DataLoader.randomSample()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Groceries"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.delegate = delegate

        let button = UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(self.fetchButtonPressed(_:)))
        navigationItem.rightBarButtonItem = button
        
        update(with: data, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isUITest = CommandLine.arguments.contains("--ui-testing")
        let isSpecificTest = CommandLine.arguments.contains("--programmatically-select-banana")
        if isUITest && isSpecificTest {
            let indexPath = IndexPath(row: 0, section: 0)
            selectRow(at: indexPath, animated: animated)
        }
    }
    
    @objc
    private func fetchButtonPressed(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        let data = try! DataLoader.randomSample()
        update(with: data, animated: true) {
            sender.isEnabled = true
        }
    }
}
