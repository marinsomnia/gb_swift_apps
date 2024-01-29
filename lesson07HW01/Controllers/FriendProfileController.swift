import UIKit

final class FriendProfileController: UIViewController, FriendProfileTabViewDelegate {
    private let friendProfileTabView = FriendProfileTabView()
    var friendsResponse: FriendsModel.Response? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        applyTheme(ThemeManager.shared.currentTheme)
        
        setupFriendProfileTabView()
        loadFriendProfile()
    }
    
    private func setupFriendProfileTabView() {
        title = "Профиль друга"
        transitioningDelegate = (tabBarController as? TabBarController)
        view.addSubview(friendProfileTabView)
        friendProfileTabView.frame = view.bounds
        friendProfileTabView.delegate = self
    }
    
    private func loadFriendProfile() {
        // Здесь ваш код для загрузки профиля друга, похожего на предыдущий loadFriendProfile
    }
    
    private func showErrorAlert(_ error: Error) {
        // Ваша имеющаяся реализация функции showErrorAlert
    }
    
    func didChangeTheme(to theme: Theme) {
        ThemeManager.shared.setTheme(theme)
    }
    
    @objc private func themeDidChange(_ notification: Notification) {
        guard let newTheme = notification.object as? Theme else { return }
        applyTheme(newTheme)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func applyTheme(_ theme: Theme) {
        friendProfileTabView.applyTheme(theme)
        view.backgroundColor = theme.backgroundColor
        let textAttributes = [NSAttributedString.Key.foregroundColor: theme.labelTextColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setFriend(_ friend: FriendsModel.Response.Friend) {
        friendProfileTabView.configure(with: friend)
    }
}
