import UIKit

final class FoodTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        registerSectionHeaders()
        register(Cell.self, forCellReuseIdentifier: "Cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerSectionHeaders() {
        let name = ArrowHeaderView.name
        let identifier = ArrowHeaderView.identifier
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
