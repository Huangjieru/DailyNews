//
//  NewsResponse.swift
//  DailyNews
//
//  Created by JRU on 2025/3/2.
//

import Foundation

struct NewsResponse: Decodable {
    let articles: [Article]
    
    struct Article: Decodable {
        let title: String?
        let description: String?
        let url: String?
        var link: URL? {
            url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap { URL(string: $0)}
        }
        let urlToImage: URL?
    }
}
