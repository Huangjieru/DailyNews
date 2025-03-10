//
//  NewsCellViewModel.swift
//  DailyNews
//
//  Created by JRU on 2025/3/2.
//

import UIKit

class NewsCellViewModel {
    var picImage: ((UIImage)->())?
    
    var title: String?
    var description: String?
    var link: URL?
     
    func setViewModel(with articles: NewsResponse.Article){
        self.title = articles.title
        self.description = articles.description
        self.link = articles.link
        
        if let newsImage = articles.urlToImage {
            NewsManager.shared.fetchImage(from: newsImage) { [weak self] (imagePic) in
                guard let self = self else {return}
                if let image = imagePic {
                    picImage?(image)
                }
            }
        }
    }
}
