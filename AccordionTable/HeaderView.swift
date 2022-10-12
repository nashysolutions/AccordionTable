import UIKit

public protocol HeaderDelegate: AnyObject {
    func headerView(_ headerView: HeaderView, didDetectTouch section: Any?)
}

public protocol HeaderDataSource: AnyObject {
    func headerViewShouldDetectTouch(_ headerView: HeaderView) -> Bool
    func headerView(_ headerView: HeaderView, rowVisibility section: Any?) -> SectionVisibility
}

public extension HeaderDataSource {
    
    func headerViewShouldDetectTouch(_ headerView: HeaderView) -> Bool {
        return true
    }
}

open class HeaderView: UITableViewHeaderFooterView {

    // A necessary evil. We must hang the model on the view :(. Using `Any`
    // because generics forces our datasource/delegate to have associatedType.
    // 1. We can't examine the tableView to see where this view belongs during
    // dequee (only after dequee). Even then, it requires looping
    // through all headers and inspecting origin of frame relative to parent. Yuck.
    // 2. We can't tag the view with the section index because delete/insert
    // events knock them out of sync.
    private var section: Any?
    
    weak var delegate: HeaderDelegate?
    
    weak var dataSource: HeaderDataSource?

    func reload(animationDuration: CGFloat) {
        guard let dataSource = dataSource else {
            return
        }
        switch dataSource.headerView(self, rowVisibility: section) {
        case .collapsed:
            close(animationDuration: animationDuration)
        case .expanded:
            open(animationDuration: animationDuration)
        }
    }
    
    func update(with section: Any) {
        self.section = section
    }
    
    open func open(animationDuration: CGFloat) {}
    
    open func close(animationDuration: CGFloat) {}
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let condition = dataSource?.headerViewShouldDetectTouch(self) ?? false
        if condition {
            delegate?.headerView(self, didDetectTouch: section)
        }
    }
}
