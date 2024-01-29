import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
    
    private let friendsController = FriendsController()
    private let groupsController = GroupsController()
    private let photosController = PhotosController()
    private let profileController = ProfileController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Прописываем табы
        friendsController.tabBarItem = UITabBarItem(
            title: "Друзья",
            image: UIImage(systemName: "person.2"),
            selectedImage: nil
        )
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
        profileController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: nil
        )

        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
        ], for: .normal)
        
        // Добавляем контроллеры в массив табов
        viewControllers = [friendsController, groupsController, photosController, profileController]

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
//        if toVC is ProfileController || fromVC is ProfileController {
//            return ProfileTransitionAnimator()
//        }
        if toVC is ProfileController {
            return ProfileTransitionAnimator()
        }
        return nil
    }
}
