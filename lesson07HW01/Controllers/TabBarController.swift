import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white // Стартовый цвет для таббара
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        applyTheme(ThemeManager.shared.currentTheme)
        
        self.delegate = self
        let apiManager = APIManager.shared
        let coreDataManager = CoreDataManager.shared
        // Создаем экземпляр FriendsController и оборачиваем его в UINavigationController
        let friendsController = FriendsController(apiManager: apiManager,coreDataManager: coreDataManager)
        let friendsNavController = UINavigationController(rootViewController: friendsController)
        friendsNavController.tabBarItem = UITabBarItem(
            title: "Друзья",
            image: UIImage(systemName: "person.2"),
            selectedImage: nil
        )
        
        // Создаем экземпляры остальных контроллеров (если они еще не в UINavigationController)
        let groupsController = GroupsController(apiManager: apiManager,coreDataManager: coreDataManager)
        let photosController = PhotosController(apiManager: apiManager,coreDataManager: coreDataManager)
        // Устанавливаем tabBarItem для каждого контроллера
        groupsController.tabBarItem = UITabBarItem(
            title: "Сообщества",
            image: UIImage(systemName: "person.3"),
            selectedImage: nil
        )
        photosController.tabBarItem = UITabBarItem(
            title: "Фотографии",
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            selectedImage: nil
        )
        
        // Добавляем контроллеры в массив табов, обернув необходимые в UINavigationController
        // viewControllers = [friendsNavController, groupsController, photosController, profileController]
        viewControllers = [friendsNavController, groupsController, photosController]
        
        // Установим текущий заголовок
        updateTitle(for: selectedViewController)
    }
    
    
    // Делегат для обновления заголовка
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTitle(for: viewController)
    }
    // Функция для обновления заголовка
    private func updateTitle(for viewController: UIViewController?) {
        title = viewController?.tabBarItem.title
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC is ProfileController {
            return ProfileTransitionAnimator()
        }
        return nil
    }
    // MARK: - Логика применения темы
    @objc private func themeDidChange(_ notification: Notification) {
        guard let newTheme = notification.object as? Theme else { return }
        applyTheme(newTheme)
    }
    
    private func applyTheme(_ theme: Theme) {
        // Применяем атрибуты шрифта и цвета к заголовкам вкладок
        UITabBarItem.appearance().setTitleTextAttributes(theme.tabBarTitleAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(theme.tabBarTitleAttributes, for: .selected)
        
        // Изменяем фоновый цвет tabBar
        tabBar.barTintColor = theme.backgroundColor
        tabBar.isTranslucent = false
        
        // Обновляем внешний вид, если вкладки уже отображаются
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes(theme.tabBarTitleAttributes, for: .normal)
                item.setTitleTextAttributes(theme.tabBarTitleAttributes, for: .selected)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
