struct UserModel: Decodable {
    let response: [User]
    
    struct User: Decodable {
        let firstName: String?
        let lastName: String?
        let photoUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
            case photoUrl = "photo_200"
        }
    }
}
