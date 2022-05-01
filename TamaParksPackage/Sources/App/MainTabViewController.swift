import UIKit
public final class MainTabViewController: UITabBarController {
    enum Tab: Int {
        case list
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }

    private func setupViewControllers() {
        let listVC = UIViewController()
        listVC.tabBarItem = UITabBarItem(
            title: "一覧",
            image: UIImage(systemName: "list.bullet"),
            tag: Tab.list.rawValue
        )

        viewControllers = [listVC]
        selectedIndex = Tab.list.rawValue
    }
}
