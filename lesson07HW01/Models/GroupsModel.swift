struct GroupsModel: Codable {
    let response: Response
    
    struct Response: Codable {
        let count: Int
        let items: [Group]
        
        struct Group: Codable {
            let name: String
            let photo: String
            let screenName: String
            let id: Int
            
            private enum CodingKeys: String, CodingKey {
                case name, id
                case photo = "photo_50"
                case screenName = "screen_name"
            }
        }
    }
}
