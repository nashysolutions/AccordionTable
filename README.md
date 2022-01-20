# AccordionTable

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://app.bitrise.io/app/c7faa96c9fe4ad70/status.svg?token=BLygyTI2Y3Y8tNJJwJUpJw&branch=master)](https://app.bitrise.io/app/c7faa96c9fe4ad70)

A wrapper for a diffable data source which facilitates collapsible table view sections. You may want to disable floating headers (see [demo](https://github.com/nashysolutions/MeltingList) app).

<img src="https://user-images.githubusercontent.com/64097812/150280515-64bbcc1b-ba85-4c56-bd4a-0b77be008e8c.gif" width="300"/>

## Implementation

The following steps are for a typical table view implementation.

### Prepare a model

<details>
    <summary>Example</summary>

    ```swift
    struct Food: Hashable {
        let id: UUID
        let title: String
        let items: [Item] // rows
    }

    struct Item: Hashable {
        let id: UUID
        let title: String
    }
    ```
</details>

Consider avoiding any user interface state management in your model structures (and hashable implementation), such as `isHighlighted`, as this will be destroyed per snapshot (use a backing store instead, such as a `Set` or `key/value` collection).

If your user interface is reloading more rows/sections than it should, it is likely the hashable implementation to blame. It seems each row must be unique within the entire dataset (not just within the section it belongs). Use GUID's on your dataset to achieve this. Alternatively, at the row level, make a reference to the section in which that row belongs (be careful of retain cycle when using classes) and use that in the hashable implementation of the row.

> If you need to use `reloadItems(_ identifiers: [ItemIdentifierType])` then you will need to use class's for your model.  

### Prepare an instance of `AccordionTable`.

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

### Prepare a table view delegate.

<details>
    <summary>Show me</summary>
    
    ```swift
    class TypicalTableViewDelegate: NSObject, UITableViewDelegate {
    
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

### Map your data

The API for [Ordered Dictionary](https://github.com/apple/swift-collections/tree/main/Sources/OrderedCollections/OrderedDictionary) is included as a dependency.

```swift
let data = OrderedDictionary<Food, [Item]>()
```

## Usage 

To reload the data, call the following on your instance of `AccordionTable`.

```swift
func update(with data: OrderedDictionary<Food, [Item]>, animated: true)
```

> On initial load, pass `animated: false`.

To programmatically select a row.

```swift
diffableTableManager.saveSelectedStateForRow(at: indexPath)
tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
``` 

To programmatically deselect a row.

```swift
diffableTableManager.saveDeselectedStateForRow(at: indexPath)
tableView.deselectRow(at: indexPath, animated: animated)
```
