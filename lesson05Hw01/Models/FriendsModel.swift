struct FriendsModel: Codable {
    let response: Response
    
    struct Response: Codable {
        let count: Int
        let items: [Friend]
        
        struct Friend: Codable {
            let id: Int
            let firstName: String
            let lastName: String
            let online: Int
            let photo: String
            
            private enum CodingKeys: String, CodingKey {
                case id
                case firstName = "first_name"
                case lastName = "last_name"
                case online
                case photo = "photo_50"
            }
        }
    }
}
