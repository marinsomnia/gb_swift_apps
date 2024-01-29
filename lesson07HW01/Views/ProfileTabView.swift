
protocol ProfileTabViewDelegate: AnyObject {
    func didChangeTheme(to theme: Theme)
}
final class ProfileTabView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let themePicker = UIPickerView()
    var themes: [Theme] = ThemeManager.shared.availableThemes
    weak var delegate: ProfileTabViewDelegate?
    var currentTheme: Theme?
    
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
        
        themePicker.dataSource = self
        themePicker.delegate = self
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(themePicker)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        themePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            themePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            themePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            themePicker.widthAnchor.constraint(equalTo: widthAnchor),
            themePicker.heightAnchor.constraint(equalToConstant: 150)
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
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themes.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return themes[row].name // Предположим, что у тем есть свойство displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTheme = themes[row]
        delegate?.didChangeTheme(to: selectedTheme)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = themes[row].name // Предположим, что у тем есть свойство name
        let textColor = currentTheme?.labelTextColor ?? .black // Используйте цвет текста текущей темы или черный по умолчанию
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: UIFont.systemFont(ofSize: 18)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func updateThemeSelection(to theme: Theme) {
        if let themeIndex = themes.firstIndex(where: { $0 == theme }) {
            themePicker.selectRow(themeIndex, inComponent: 0, animated: true)
        }
    }
    
}
