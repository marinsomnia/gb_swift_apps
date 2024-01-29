import UIKit

struct Theme: Equatable {
    let name: String
    let backgroundColor: UIColor
    let labelTextColor: UIColor
    let cellBackgroundColor: UIColor
    let tabBarTitleAttributes: [NSAttributedString.Key: Any]
    
    static func ==(lhs: Theme, rhs: Theme) -> Bool {
        return lhs.name == rhs.name
    }
    
    static let light: Theme = Theme(
        name: "Светлая",
        backgroundColor: UIColor.white,
        labelTextColor: UIColor.darkGray,
        cellBackgroundColor: UIColor.white,
        tabBarTitleAttributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14)
        ]
    )
    
    static let dark: Theme = Theme(
        name: "Темная",
        backgroundColor: UIColor.black,
        labelTextColor: UIColor.lightGray,
        cellBackgroundColor: UIColor.darkText,
        tabBarTitleAttributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14)
        ]
    )
    
    static let blue: Theme = Theme(
        name: "Синяя",
        backgroundColor: UIColor.cyan,
        labelTextColor: UIColor.black,
        cellBackgroundColor: UIColor.lightGray,
        tabBarTitleAttributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 10)
        ]
    )
}
