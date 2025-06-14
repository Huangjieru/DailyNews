//
//  NewsViewModel.swift
//  DailyNews
//
//  Created by JRU on 2025/3/2.
//

import Foundation

class NewsViewModel {
    enum Section: Int, CaseIterable {
        case topHeadline
        case news
    }
    
    var reloadData: (()->())?
    var topHeadlineCellVM: TopHeadlineCellViewModel?
    var newsCellVMs = [NewsCellViewModel]()
    
    func fetchNews(country: String){
        newsCellVMs = []
        
        let parameters = ["country": country]
        NewsManager.shared.managers(object: NewsResponse.self, method: .get, apiUrl: APIUrl.topHeadlines(type: .topHeadlines), parameters: parameters) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let newsResponse):
                setNewsVMs(newsResponse: newsResponse)
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
    
    func fetchTopHeadline() {
        topHeadlineCellVM = TopHeadlineCellViewModel()
        
        let parameters = ["pageSize" : 5, "country": "us"] as [String : Any]
        NewsManager.shared.managers(object: NewsResponse.self, method: .get, apiUrl: APIUrl.topHeadlines(type: .topHeadlines), parameters: parameters) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let newsResponse):
                self.setTopHeadlineCellVM(response: newsResponse)
                self.reloadData?()
            case .failure(let error):
                print("沒有Response: \(error)")
            }
        }
    }
    
    func setNewsVMs(newsResponse: NewsResponse) {
        newsResponse.articles.forEach { news in
            let newsCellVM = NewsCellViewModel()
            newsCellVM.setViewModel(with: news)
            self.newsCellVMs.append(newsCellVM)
        }
    }
    
    func setNumberOfSections() -> Int {
        return Section.allCases.count
    }
    
    func setNumberOfRowsInSection(section: Int) -> Int {
        switch Section(rawValue: section) {
        case .topHeadline:
            return 1
        case .news:
            return newsCellVMs.count
        default:
            return 0
        }
    }
}

extension NewsViewModel {
    
    private func setTopHeadlineCellVM(response: NewsResponse) {
        topHeadlineCellVM = TopHeadlineCellViewModel()
        topHeadlineCellVM?.setViewModel(articles: response.articles)
    }
}
