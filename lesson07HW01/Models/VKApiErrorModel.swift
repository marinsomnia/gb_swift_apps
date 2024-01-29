// Модель для декодирования стандартного ответа об ошибке от API ВКонтакте.
struct VKApiErrorModel: Decodable {
    let error: VKError
    
    struct VKError: Decodable {
        let errorCode: Int
        let errorMessage: String
        let requestParams: [RequestParam]?
        
        enum CodingKeys: String, CodingKey {
            case errorCode = "error_code"
            case errorMessage = "error_msg"
            case requestParams = "request_params"
        }
        
        struct RequestParam: Decodable {
            let key: String
            let value: String
        }
    }
}
