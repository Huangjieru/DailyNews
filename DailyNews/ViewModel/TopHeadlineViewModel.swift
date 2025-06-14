//
//  TopHeadlineViewModel.swift
//  DailyNews
//
//  Created by JRU on 2025/3/22.
//

import UIKit

class TopHeadlineViewModel {
    
    var title: String?
    var imageUrl: URL?
    
    func setViewModel(article: NewsResponse.Article) {
        self.title = article.title
        self.imageUrl = article.urlToImage
    }
}
