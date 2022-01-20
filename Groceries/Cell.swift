import UIKit

final class Cell: UITableViewCell {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        isAccessibilityElement = true
    }

    func update(with food: Item) {
        let title = food.title
        textLabel?.text = title
        accessibilityLabel = title
    }
}
