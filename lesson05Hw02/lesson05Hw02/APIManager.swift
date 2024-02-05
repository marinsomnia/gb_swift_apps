import Foundation

class APIManager: ObservableObject {
    @Published var newsList: [NewsListModel.News] = []

    func fetchNewsList() {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/news/?lang=&fields=id,title,publication_date&expand=&order_by=&text_format=text&ids=&location=&actual_only=true") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(NewsListModel.self, from: data) {
                    DispatchQueue.main.async {
                        self.newsList = decodedResponse.results
                    }
                    return
                } else {
                    print("encodding error")
                }
            } else {
                print("cant load the data")
            }
        }.resume()
    }
}
