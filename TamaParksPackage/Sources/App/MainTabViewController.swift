import ListFeature
import MapFeature
import Resources
import UIKit

public final class MainTabViewController: UITabBarController {
    enum Tab: Int {
        case list
        case map
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupViewControllers()
    }

    private func setupAppearance() {
        tabBar.tintColor = Asset.parkGreen.color
    }

    private func setupViewControllers() {
        let listVC = UINavigationController(rootViewController: ParkListViewController())
        listVC.tabBarItem = UITabBarItem(
            title: L10n.TabTitle.list,
            image: UIImage(systemName: "list.bullet"),
            tag: Tab.list.rawValue
        )

        let mapVC = ParkMapViewController()
        mapVC.tabBarItem = UITabBarItem(
            title: "マップ",
            image: UIImage(systemName: "map"),
            tag: Tab.map.rawValue
        )

        viewControllers = [listVC, mapVC]
        selectedIndex = Tab.list.rawValue
    }
}
