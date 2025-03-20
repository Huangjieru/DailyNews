//
//  NewsCellViewModel.swift
//  DailyNews
//
//  Created by JRU on 2025/3/2.
//

import UIKit

class NewsCellViewModel {
    var title: String?
    var description: String?
    var imageUrl: URL?
    var link: URL?
     
    func setViewModel(with articles: NewsResponse.Article){
        self.title = articles.title
        self.description = articles.description
        self.imageUrl = articles.urlToImage
        self.link = articles.link
    }
}
