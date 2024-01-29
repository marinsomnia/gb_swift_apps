import UIKit
import WebKit

final class AuthController: UIViewController {
    
    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        let clientId = "51813520"
        let authURLString = "https://oauth.vk.com/authorize?client_id=\(clientId)&redirect_uri=https://oauth.vk.com/blank.html&262150&display=mobile&response_type=token"
        
        if let url = URL(string: authURLString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
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
        navigationController?.pushViewController(TabBarController(), animated: true)
    }
}
