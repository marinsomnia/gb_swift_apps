import UIKit

class PhotosViewCell: UICollectionViewCell {
    // UIImageView для отображения фотографии.
    private let photoImageView = UIImageView()
    
    // Инициализатор для создания ячейки через код.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // Инициализатор для создания ячейки через Interface Builder или Storyboard.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // Метод для настройки внешнего вида ячейки.
    private func setupViews() {
        // Отключение авто-констрейнтов для photoImageView,
        // чтобы можно было установить свои констрейнты в коде.
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        // Добавление photoImageView в contentView ячейки.
        contentView.addSubview(photoImageView)
        
        // Активация констрейнтов для photoImageView, чтобы она заполняла всё доступное пространство ячейки.
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        // Установка режима масштабирования содержимого изображения и обрезания его по границам ячейки.
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
    }
    
    // Метод для конфигурации ячейки с использованием данных о фотографии.
    public func configureWithPhoto(with photo: PhotosModel.Response.Photo) {
        // Сначала очистите текущее изображение, чтобы предотвратить отображение неправильного изображения из-за переиспользования ячеек.
        photoImageView.image = nil
        
        // Попытка найти URL фотографии, где одна из сторон больше 300 пикселей.
        var urlString = photo.sizes
            .compactMap { size -> String? in
                let urlComponents = size.url.components(separatedBy: "?")
                guard let query = urlComponents.last, urlComponents.count > 1 else { return nil }
                let queryParams = query.components(separatedBy: "&")
                let sizeParam = queryParams.first { $0.contains("size=") }
                guard let sizeValue = sizeParam?.components(separatedBy: "=").last else { return nil }
                let dimensions = sizeValue.components(separatedBy: "x").compactMap { Int($0) }
                guard dimensions.count == 2 else { return nil }
                let (width, height) = (dimensions[0], dimensions[1])
                return (width > 300 || height > 300) ? size.url : nil
            }
            .first
        
        // Если не найден URL с соответствующим размером, используем первый URL из массива sizes.
        urlString = urlString ?? photo.sizes.first?.url
        print(urlString!)
        if let urlString = urlString, let url = URL(string: urlString) {
            // Асинхронная загрузка изображения с использованием URLSession.
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                // Проверяем наличие данных и создаем изображение.
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Устанавливаем загруженное изображение в photoImageView.
                        self?.photoImageView.image = image
                    }
                }
            }.resume()
        } else {
            // Если URL нет, устанавливаем изображение-заполнитель.
            photoImageView.image = UIImage(named: "placeholder")
        }
    }
}
