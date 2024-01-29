import UIKit
class ThemeManager {
    
    static let shared = ThemeManager()
    static let themeDidChangeNotification = NSNotification.Name("ThemeManagerThemeDidChange")
    
    private(set) var currentTheme: Theme {
        didSet {
            NotificationCenter.default.post(name: ThemeManager.themeDidChangeNotification, object: currentTheme)
        }
    }
    
    private(set) var availableThemes: [Theme]
    
    private init() {
        // Инициализация доступных тем
        self.availableThemes = [Theme.light, Theme.dark, Theme.blue]
        
        // Установка темы по умолчанию
        self.currentTheme = .light
    }
    
    func setTheme(_ theme: Theme) {
        currentTheme = theme
        // Сохранение выбранной темы, чтобы она могла быть восстановлена при следующем запуске
        UserDefaults.standard.set(theme.name, forKey: "selectedThemeName")
    }
    
    func theme(named themeName: String) -> Theme? {
        return availableThemes.first { $0.name == themeName }
    }
}
