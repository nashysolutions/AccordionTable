import UIKit

final class FoodTableViewDelegate: TypicalTableViewDelegate<Food, Item> {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        ArrowHeaderView.height
    }
}
