//
//  ContentView.swift
//  VoaNews
//
//  Created by User on 23/04/24.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    @StateObject private var newsVM = NewsVM()
    @State private var searchText: String = ""
    @State private var isRedacted: Bool = true
    
    var newsSearchResults: [NewsArticle]{
        guard !searchText.isEmpty else{
            return newsVM.articles
        }
        return newsVM.articles.filter{
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack{
            List{
                if isRedacted{
                    ForEach(newsSearchResults){ article in
                        HStack{
                            AsyncImage(url: URL(string: article.image)) {image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }placeholder: {
                                ZStack {
                                    WaitingView()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            VStack(alignment: .leading, spacing: 16) {
                                Text(article.title)
                                    .font(.system(.headline, design: .rounded))
                                    .lineLimit(2)
                                HStack{
                                    Text(article.isoDate.relativeToCurrentDate())
                                        .lineLimit(1)
                                    
                                    Button{
                                        let vc = SFSafariViewController(url: URL(string: article.link)!)
                                        UIApplication.shared.firstKeyWindow?.rootViewController?.present(vc, animated: true)
                                    } label: {
                                        Text("Selengkapnya")
                                            .lineLimit(1)
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                            
                            
                            
                        }
                    }
                    .redacted(reason: .placeholder)
                } else {
                    ForEach(newsSearchResults){ article in
                        HStack{
                            AsyncImage(url: URL(string: article.image)) {image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }placeholder: {
                                ZStack {
                                    WaitingView()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            VStack(alignment: .leading, spacing: 16) {
                                Text(article.title)
                                    .font(.system(.headline, design: .rounded))
                                    .lineLimit(2)
                                HStack{
                                    Text(article.isoDate.relativeToCurrentDate())
                                        .lineLimit(1)
                                    
                                    Button{
                                        let vc = SFSafariViewController(url: URL(string: article.link)!)
                                        UIApplication.shared.firstKeyWindow?.rootViewController?.present(vc, animated: true)
                                    } label: {
                                        Text("Selengkapnya")
                                            .lineLimit(1)
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                            
                            
                            
                        }
                    }
                }
                
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    isRedacted = false
                }
            }
            .refreshable {
                isRedacted = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    isRedacted = false
                }
                await newsVM.fetchNews()
            }
            .listStyle(.plain)
            .navigationTitle(Constants.newsTitle)
            .task {
                await newsVM.fetchNews()
            }
            
            
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search News Here")
        .overlay{
            if newsSearchResults.isEmpty{
                ContentUnavailableView.search(text: searchText)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
@ViewBuilder
func WaitingView() -> some View {
    VStack(spacing: 20){
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.pink)
        
        Text("Fetch image.......")
        
    }
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { scene in
                scene as? UIWindowScene
            }
            .filter { filter in filter.activationState == .foregroundActive
            }
            .first?.keyWindow
    }
}

