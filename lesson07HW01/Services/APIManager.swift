import Foundation

protocol APIManagerProtocol {
    func getData<T: Decodable>(for request: APIManager.Requests, completion: @escaping (Result<T, Error>) -> Void)
}

final class APIManager:APIManagerProtocol {
    private let session: URLSession
    
    static private var token = ""
    static private var userId = ""
    
    static func setCredentials(_ token: String, _ userId: String) {
        self.token = token
        self.userId = userId
        print(token)
        print(userId)
    }
    
    enum Requests {
        case friends
        case groups
        case photos
        case profile
    }
    
    static let shared = APIManager()
    
    private init() {
        session = URLSession.shared
    }
    
    private func getRequestUrl(for request: Requests) -> URL? {
        var urlString = ""
        
        switch request {
        case .friends:
            urlString = "https://api.vk.com/method/friends.get?fields=nickname,photo_50,photo_200_orig,online&access_token=\(APIManager.token)&v=5.199"
        case .groups:
            urlString = "https://api.vk.com/method/groups.get?extended=1&access_token=\(APIManager.token)&v=5.199"
        case .profile:
            urlString =  "https://api.vk.com/method/users.get?fields=photo_200&owner_id=\(APIManager.userId)&access_token=\(APIManager.token)&v=5.199"
        case .photos:
            urlString = "https://api.vk.com/method/photos.get?owner_id=\(APIManager.userId)&access_token=\(APIManager.token)&v=5.199&album_id=profile"
            //            urlString = "https://api.vk.com/method/photos.getAll?owner_id=\(APIManager.userId)&access_token=\(APIManager.token)&v=5.199"
        }
        
        guard let url = URL(string: urlString) else {
            print("Error while creating URL")
            return nil
        }
        
        return url
    }
    
    
    func getData<T: Decodable>(for request: Requests, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = getRequestUrl(for: request) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10 // Установка таймаута в 10 секунд
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Ошибка декодирования JSON: \(error)")
                
                // Попытка декодировать возможную ошибку от VK API
                if let apiError = try? JSONDecoder().decode(VKApiErrorModel.self, from: data) {
                    let errorMessage = apiError.error.errorMessage
                    print("Ошибка VK API: \(errorMessage)")
                    completion(.failure(NSError(domain: "", code: apiError.error.errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } else {
                    print("Ошибка: Невозможно декодировать ошибку VK API.")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}
