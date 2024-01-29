import UIKit

class FriendsViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.tintColor = .gray // Цвет иконки
        return imageView
    }()

    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let statusIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    // Инициализаторы
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusIndicatorView)
        
        // Установка Auto Layout
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        // Расстановка констрейнтов
        NSLayoutConstraint.activate([
          contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
          profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
          profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // Центрирование по вертикали внутри contentView
          profileImageView.widthAnchor.constraint(equalToConstant: 50), // Ширина фотографии
          profileImageView.heightAnchor.constraint(equalToConstant: 50), // Высота фотографии
          
          nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
          nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          
          statusIndicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
          statusIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
          statusIndicatorView.widthAnchor.constraint(equalToConstant: 10), // Ширина индикатора статуса
          statusIndicatorView.heightAnchor.constraint(equalToConstant: 10) // Высота индикатора статуса
        ])
    }
    
    // Метод для конфигурации ячейки данными
    func configureWithFriend(_ friend: FriendsModel.Response.Friend) {
        nameLabel.text = friend.firstName + " " + friend.lastName

        // Асинхронная загрузка изображения
        if let url = URL(string: friend.photo) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }.resume()
        }
        
        // Установка индикатора статуса
        if friend.online == 1 {
            statusIndicatorView.backgroundColor = .green
        } else {
            statusIndicatorView.backgroundColor = .gray
        }
    }
}
