//
//  TopHeadlineCellViewModel.swift
//  DailyNews
//
//  Created by JRU on 2025/3/6.
//

import UIKit

class TopHeadlineCellViewModel {
    
    var topHeadlineVMs: [TopHeadlineViewModel] = []
    var articles: [NewsResponse.Article] = []
    var showImageIndex = 1
    
    func setViewModel(articles: [NewsResponse.Article]) {
        topHeadlineVMs = []
        self.articles = articles
        self.articles.insert(articles.last!, at: 0)
        self.articles.insert(articles[0], at: articles.count + 1)
        self.articles.forEach { article in
            let viewModel = TopHeadlineViewModel()
            viewModel.setViewModel(article: article)
            topHeadlineVMs.append(viewModel)
        }
    }
    
    func getImageTagURL(index: Int, topHeadlineVMs: [TopHeadlineViewModel]) -> TopHeadlineViewModel {
        var topHeadlineVM: TopHeadlineViewModel?
        
        switch index {
        case 0:
            topHeadlineVM = topHeadlineVMs.last
            
        case (topHeadlineVMs.count):
            topHeadlineVM = topHeadlineVMs.first
            
        default:
            topHeadlineVM = topHeadlineVMs[index - 1]
        }
        return topHeadlineVM!
    }
    
    func autoScroll() {
        if showImageIndex == topHeadlineVMs.count {
            showImageIndex = 2
        }else {
            showImageIndex += 1
        }
    }
}
