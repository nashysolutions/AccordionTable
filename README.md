# AccordionTable

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A wrapper for a diffable dataSource which facilitates collapsible table view sections.

## Implementation

The following steps are for a typical table view implementation. You may want to do some additional customisation, such as: -
 
1. subclass `UITableViewDiffableDataSource`
2. provide several header view types in your `headerProvider`
3. disable floating table view headers (see demo app)

### Setup

If your user interface is reloading more rows/sections than it should, it is likely the hashable implementation to blame. It seems each row must be unique within the entire dataset (not just within the section it belongs). Use GUID's on your dataset to achieve this. Alternatively, at the row level, make a reference to the section in which that row belongs (be careful of retain cycle) and use that in the hashable implementation of the row.

<details>
    <summary>Example</summary>
    
    Consider avoiding any user interface state management in your model structures (and hashable implementation), such as `isHighlighted`, as this will be destroyed per snapshot (use a backing store instead, such as a `Set` or `key/value` collection).

    ```swift
    struct Food: Hashable {
        let title: String
        let items: [Item] // rows
    }

    struct Item: Hashable {
        let title: String
    }
    ```
</details>

Prepare an instance of `AccordionTable`.

<details>
    <summary>Show me</summary>
    
    ```swift
    let tableDataSource = UITableViewDiffableDataSource<Food, Item>(
        tableView: tableView,
        cellProvider: cellProvider
    )
    
    let diffableTableManager = AccordionTable<Food, Item>(
        dataSource: tableDataSource,
        headerProvider: headerProvider
    )
    ```
</details>

Prepare a table view delegate which consumes an instance of `AccordionTable`.

<details>
    <summary>Show me</summary>
    
    ```swift
    class TypicalTableViewDelegate<Food, Item>: NSObject, UITableViewDelegate {
    
        let tableManager: AccordionTable<Food, Item>
        
        init(_ tableManager: AccordionTable<Food, Item>) {
            self.tableManager = tableManager
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            tableManager.viewForHeader(in: tableView, at: section)
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            tableManager.selectRowIfNeeded(in: tableView, at: indexPath)
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let isSelected = tableManager.toggleSelectedStateForRow(at: indexPath) else {
                return
            }
            if !isSelected {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            tableManager.saveDeselectedStateForRow(at: indexPath)
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0 // your header height
        }
    }
    ```
</details>

You will need to map your data to an [Ordered Dictionary](https://github.com/apple/swift-collections/tree/main/Sources/OrderedCollections/OrderedDictionary), the API for which is included as a dependency.

```swift
let data = OrderedDictionary<Food, [Item]>()
```

### Usage

If you need to use `reloadItems(_ identifiers: [ItemIdentifierType])` then you will need to use class's for your model. 

If you need to programmatically select or deselect a row, make sure to update your model before updating your view.

```swift
diffableTableManager.saveSelectedStateForRow(at: indexPath)
tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)

diffableTableManager.saveDeselectedStateForRow(at: indexPath)
tableView.deselectRow(at: indexPath, animated: animated)
``` 
