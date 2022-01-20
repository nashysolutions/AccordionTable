import UIKit

final class Cell: UITableViewCell {
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isAccessibilityElement = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            accessibilityTraits = isSelected ? .selected : .none
        }
    }
    
    func update(with food: Item) {
        let title = food.title
        textLabel?.text = title
        accessibilityLabel = title
    }
}
