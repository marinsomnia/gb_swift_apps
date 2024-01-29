struct GroupsModel: Codable {
  let response: Response
  
  struct Response: Codable {
    let count: Int
    let items: [Group]
     
    struct Group: Codable {
      let name: String
      let photo: String
       
      private enum CodingKeys: String, CodingKey {
        case name
        case photo = "photo_50"
      }
    }
  }
}
