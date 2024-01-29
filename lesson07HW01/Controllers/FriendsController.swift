import UIKit

final class FriendsController: UITableViewController {
    private var data = [FriendsModel.Response.Friend]()
    private let refresh = UIRefreshControl()
    private var apiManager: APIManagerProtocol
    private var coreDataManager: CoreDataManagerProtocol
    let friendProfileController: FriendProfileController
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(apiManager: APIManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        self.friendProfileController = FriendProfileController()
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        
        // Создание кнопки для перехода в профиль пользователя
        let rightBarButton = UIBarButtonItem(title: "Профиль", style: .plain, target: self, action: #selector(goToProfileScreen))
        // Установка этой кнопки как кнопки справа в навигационной панели
        navigationItem.rightBarButtonItem = rightBarButton
        // Устанаваливаем FriendsController в качестве делегата для навигационного контроллера
        self.navigationController?.delegate = self
        
        let profileController = ProfileController(apiManager: apiManager, coreDataManager: coreDataManager)
        
        profileController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: nil
        )
        
        let logoutButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutButton
        
        applyTheme(ThemeManager.shared.currentTheme)
        setupTableView()
        loadFriendsData()
    }
    private func setupTableView() {
        view.backgroundColor = .white
        tableView.refreshControl = refresh
        tableView.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        tableView.register(FriendsViewCell.self, forCellReuseIdentifier: "FriendsViewCell")
        refresh.addTarget(self, action: #selector(loadFriendsData), for: .valueChanged)
        
    }
    
    // Selector, который будет вызываться при нажатии на кнопку перехода в профиль пользователя
    @objc func goToProfileScreen() {
        navigationController?.pushViewController(ProfileController(apiManager: apiManager, coreDataManager: coreDataManager), animated: true)
    }
    
    @objc func logout() {
        let authController = AuthController()
        // TODO: Настроbnm AuthController, очистка пользовательских данных, локальное хранилище и т.д.
        
        // Получаем UIWindowScene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        // Устанавливаем AuthController в качестве rootViewController для UIWindow
        if let window = windowScene.windows.first {
            window.rootViewController = authController
            window.makeKeyAndVisible()            
        }
    }
    
    @objc func loadFriendsData() {
        // Загружаем данные из Core Data
        
        // Пытаемся получить данные из сети
        apiManager.getData(for: .friends) { [weak self] (result: Result<FriendsModel, Error>) in
            DispatchQueue.main.async {
                self?.refresh.endRefreshing()
                switch result {
                case .success(let friendsModel):
                    let friends = friendsModel.response.items
                    self?.friendProfileController.friendsResponse = friendsModel.response
                    self?.data = friends
                    self?.tableView.reloadData()
                    self?.coreDataManager.saveFriends(friends)
                case .failure(let error):
                    // Ошибка загрузки с сети, показываем alert с ошибкой и продолжаем показывать кешированные данные
                    self?.data = self?.coreDataManager.fetchFriends() ?? []
                    self?.showErrorAlert(error)
                }
            }
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        let message = "Не удалось обновить данные. Последние актуальные данные на \(coreDataManager.fetchFriendsLastUpdate()). Ошибка: \(error.localizedDescription)"
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsViewCell", for: indexPath) as? FriendsViewCell else {
            return UITableViewCell()
        }
        cell.configureWithFriend(data[indexPath.row])
        cell.applyTheme(ThemeManager.shared.currentTheme)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Получаем данные друга, по которому тапнули
        let friend = data[indexPath.row]
        
        // Создаём новый экземпляр FriendProfileController
        let friendProfileController = FriendProfileController()
        
        // Передаём выбранного друга в friendProfileController (нужно реализовать метод setFriend в FriendProfileController)
        friendProfileController.setFriend(friend)
        
        // Показываем FriendProfileController
        navigationController?.pushViewController(friendProfileController , animated: true)
        
        // Снимаем выделение с ячейки
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc private func themeDidChange(_ notification: Notification) {
        guard let newTheme = notification.object as? Theme else { return }
        applyTheme(newTheme)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        let textAttributes = [NSAttributedString.Key.foregroundColor: theme.labelTextColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        refresh.tintColor = theme.labelTextColor
        tableView.reloadData()
    }
}
// Анимация перехода к PrfileController()
extension FriendsController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation:
                              UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
        if operation == .push && toVC is ProfileController {
            return ProfileTransitionAnimator()
        }
        return nil
    }
}
