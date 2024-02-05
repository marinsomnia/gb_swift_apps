import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: NewsListView()) {
                    Text("Перейти к новостям")
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle("Главная страница")
        }
    }
}

#Preview {
    ContentView()
}

struct NewsItem: Identifiable {
    let id: UUID
    let title: String
    let publicationDate: Date
}

struct NewsListView: View {
    @ObservedObject var apiManager = APIManager()
    var body: some View {
        List(apiManager.newsList) { item in
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                // Конвертируем Int в Date
                Text(Date(timeIntervalSince1970: TimeInterval(item.publicationDate)), style: .date)
                    .font(.subheadline)
            }
        }
        .onAppear(perform: loadNews)
        .navigationTitle("Новости")
    }

    func loadNews() {
        apiManager.fetchNewsList()
    }
}
