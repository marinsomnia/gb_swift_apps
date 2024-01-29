import UIKit

protocol FriendProfileTabViewDelegate: AnyObject {
    func didChangeTheme(to theme: Theme)
}
final class FriendProfileTabView: UIView {
    weak var delegate: FriendProfileTabViewDelegate?
    let imageView = UIImageView()
    let nameLabel = UILabel()
    var themes: [Theme] = ThemeManager.shared.availableThemes
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
        ])
    }
    
    func configure(with friendData: FriendsModel.Response.Friend) {
        nameLabel.text = "\(friendData.firstName) \(friendData.lastName)"
        let photoUrl = URL(string: friendData.photo200)
        URLSession.shared.dataTask(with: photoUrl!) { [weak self] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
    
    // Функция для применения темы
    func applyTheme(_ theme: Theme) {
        backgroundColor = theme.backgroundColor
        nameLabel.textColor = theme.labelTextColor
        imageView.backgroundColor = theme.cellBackgroundColor
        // Информирование делегата об изменении темы
        delegate?.didChangeTheme(to: theme)
    }
}
