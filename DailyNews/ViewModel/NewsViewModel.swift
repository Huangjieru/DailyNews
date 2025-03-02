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
    
    func fetchNews(){
        newsCellVMs = []
        NewsManager.shared.fetchItems { [weak self] newsList in
            guard let self = self else {return}
            newsList?.forEach { news in
                let newsCellVM = NewsCellViewModel()
                newsCellVM.setViewModel(with: news)
                self.newsCellVMs.append(newsCellVM)
            }
            self.reloadData?()
        }
    }
    
    func fetchSearchNews(text: String){
        newsCellVMs = []
        NewsManager.shared.fetchSearchNews(text: text) { [weak self] newsList in
            guard let self = self else {return}
            if let newsList{
                DispatchQueue.main.async {
                    newsList.forEach { news in
                        let newsCellVM = NewsCellViewModel()
                        newsCellVM.setViewModel(with: news)
                        self.newsCellVMs.append(newsCellVM)
                    }
                    self.reloadData?()
                }
            }
        }
    }
}
