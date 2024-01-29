import UIKit
import WebKit

final class AuthController: UIViewController {
    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: ThemeManager.themeDidChangeNotification, object: nil)
        applyTheme(ThemeManager.shared.currentTheme)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        let clientId = "51816955"
        let authURLString = "https://oauth.vk.com/authorize?client_id=\(clientId)&redirect_uri=https://oauth.vk.com/blank.html&262150&display=mobile&response_type=token"
        
        if let url = URL(string: authURLString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc private func themeDidChange(_ notification: Notification) {
        guard let newTheme = notification.object as? Theme else { return }
        applyTheme(newTheme)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func applyTheme(_ theme: Theme) {
        // Тут будет код для применения темы если потребуется
    }
    
}

extension AuthController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        APIManager.setCredentials(params[ "access_token" ]!, params[ "user_id" ]!)
        decisionHandler(.cancel)
        webView.removeFromSuperview()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            window.rootViewController = TabBarController()
            window.makeKeyAndVisible()
        }
    }
    
}
