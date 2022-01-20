import UIKit

final class Cell: UITableViewCell {

    func update(with food: Item) {
        let title = food.title
        textLabel?.text = title
        accessibilityLabel = title
    }
}
