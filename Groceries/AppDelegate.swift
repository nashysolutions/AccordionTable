import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
        return true
    }

    private func makeRootViewController() -> UIViewController {
        
        let controller = FoodsViewController(tableView: .init(frame: .zero, style: .plain)) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
            cell.update(with: item)
            return cell
        } headerProvider: { tableView, index, section in
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ArrowHeaderView.identifier)
            guard let view = view as? ArrowHeaderView else {
                fatalError()
            }
            view.updateTitle(with: section.title)
            return view
        }
        
        if CommandLine.arguments.contains("--ui-testing") {
            controller.data = try! DataLoader.originalData()
        }
        
        return UINavigationController(rootViewController: controller)
    }
}
