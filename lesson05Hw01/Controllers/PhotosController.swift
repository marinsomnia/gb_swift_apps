import UIKit

final class PhotosController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var data = [PhotosModel.Response.Photo]()
    private let reuseIdentifier = "PhotoCell"
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let itemsPerRow: CGFloat = 2
    private let refresh = UIRefreshControl()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        // Установка интервалов между элементами и линиями секций
        layout.minimumInteritemSpacing = sectionInsets.left
        layout.minimumLineSpacing = sectionInsets.top
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PhotosViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        // Добавление функционала pull-to-refresh
        refresh.addTarget(self, action: #selector(loadPhotosData), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        // Загрузка данных
        loadPhotosData()
    }
    
    // Загрузка данных
    @objc private func loadPhotosData() {
        APIManager.shared.getData(for: .photos) { [weak self] photos in
            guard let photos = photos as? [PhotosModel.Response.Photo] else {
                DispatchQueue.main.async { // добавим сюда это, а то индикатор загрузки подвисает если от апи ошика прилетает
                    self?.collectionView.refreshControl?.endRefreshing()
                }
                return
            }
            self?.data = photos
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("photos data count "+data.count.description)
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotosViewCell else {
            fatalError("Unable to dequeue PhotosViewCell")
        }
        
        let photo = data[indexPath.item]
        // Настройка ячейки с использованием данных модели
        cell.configureWithPhoto(with: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Здесь можно добавлять другие методы делегата UICollectionViewDelegateFlowLayout
}
