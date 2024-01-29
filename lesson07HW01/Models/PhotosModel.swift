struct PhotosModel: Decodable {
    let response: Response
    
    struct Response: Decodable {
        let items: [Photo]
        
        struct Photo: Decodable {
            let sizes: [Size]
            
            struct Size: Decodable {
                let url: String
                
            }
        }
    }
}
