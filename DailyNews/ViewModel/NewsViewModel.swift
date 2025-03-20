//
//  NewsViewModel.swift
//  DailyNews
//
//  Created by JRU on 2025/3/2.
//

import Foundation

class NewsViewModel {
    var reloadData: (()->())?
    
    var newsCellVMs = [NewsCellViewModel]()
    
    func fetchNews(country: String){
        newsCellVMs = []
        
        let parameters = ["country": country]
        NewsManager.shared.managers(object: NewsResponse.self, method: .get, apiUrl: APIUrl.topHeadlines(type: .topHeadlines), parameters: parameters) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let newsResponse):
                newsResponse.articles.forEach { news in
                    let newsCellVM = NewsCellViewModel()
                    newsCellVM.setViewModel(with: news)
                    self.newsCellVMs.append(newsCellVM)
                }
                self.reloadData?()
            case .failure(let error):
                print("沒有Response: \(error)")
            }
        }
    }
    
    //搜尋新聞的API
    func fetchSearchNews(text: String){
        newsCellVMs = []
        
        let parameters = ["searchIn" : "title", "q" : text]
        NewsManager.shared.managers(object: NewsResponse.self, method: .get, apiUrl: APIUrl.everything(type: .everything), parameters: parameters) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let newsResponse):
                DispatchQueue.main.async {
                    newsResponse.articles.forEach { news in
                        let newsCellVM = NewsCellViewModel()
                        newsCellVM.setViewModel(with: news)
                        self.newsCellVMs.append(newsCellVM)
                    }
                    self.reloadData?()
                }
            case .failure(let error):
                print("沒有Response: \(error)")
            }
        }
    }
}
