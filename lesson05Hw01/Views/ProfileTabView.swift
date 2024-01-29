import UIKit
final class ProfileTabView: UIView {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

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
        imageView.layer.cornerRadius = 50
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 18)

        addSubview(imageView)
        addSubview(nameLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
    }

    func configure(with userData: UserModel.User) {
        nameLabel.text = "\(userData.firstName ?? "") \(userData.lastName ?? "")"
        if let photoUrlString = userData.photoUrl, let photoUrl = URL(string: photoUrlString) {
            URLSession.shared.dataTask(with: photoUrl) { [weak self] data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }.resume()
        }
    }
}
