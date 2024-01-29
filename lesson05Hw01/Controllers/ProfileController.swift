import UIKit

final class ProfileController: UIViewController {
  private let profileTabView = ProfileTabView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupProfileTabView()
    loadUserProfile()
  }

  private func setupProfileTabView() {
    view.backgroundColor = .white
    title = "Профиль"
    transitioningDelegate = (tabBarController as? TabBarController)
    navigationController?.navigationBar.tintColor = .black
    navigationController?.navigationBar.barTintColor = .white
    view.addSubview(profileTabView)
    profileTabView.frame = view.bounds // Располагаем ProfileTabView на весь экран
  }

  private func loadUserProfile() {
    APIManager.shared.getData(for: .profile) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case let userData as [UserModel.User]:
          if let user = userData.first {
            self?.profileTabView.configure(with: user)
          }
        default:
          print("Error load user profile data")
          break
        }
      }
    }
  }
}
