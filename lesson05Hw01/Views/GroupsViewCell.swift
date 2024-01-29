import UIKit

class GroupsViewCell: UITableViewCell {

  private let groupImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 25 // половина высоты изображения
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .gray
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }
   
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
   
  private func setupViews() {
    contentView.addSubview(groupImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(descriptionLabel)

    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70),
      groupImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      groupImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // Центрирование по вертикали внутри contentView
      groupImageView.widthAnchor.constraint(equalToConstant: 50), // Размеры фотографии
      groupImageView.heightAnchor.constraint(equalToConstant: 50),

      nameLabel.leadingAnchor.constraint(equalTo: groupImageView.trailingAnchor, constant: 10),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
      nameLabel.topAnchor.constraint(equalTo: groupImageView.topAnchor),

      descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
      descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
      
      
    ])
  }
   
  func configureWithGroup(_ group: GroupsModel.Response.Group) {
    nameLabel.text = group.name
    descriptionLabel.text = group.name // не понял тут что должно быть в описании группы
    
    // Асинхронная загрузка изображения
    if let url = URL(string: group.photo) {
      URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data, let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self.groupImageView.image = image
          }
        }
      }.resume()
    }
  }
   
  override func prepareForReuse() {
    super.prepareForReuse()
    groupImageView.image = nil
    nameLabel.text = nil
    descriptionLabel.text = nil
  }
}
