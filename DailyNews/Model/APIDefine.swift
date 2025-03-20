//
//  APIDefine.swift
//  DailyNews
//
//  Created by JRU on 2025/3/8.
//

import Foundation

//let APITimeout: Double = 60.0

enum APIUrl {
    case topHeadlines(type: TopHeadlines)
    case everything(type: Everything)
    
    enum TopHeadlines: String {
        case topHeadlines = "/top-headlines"
        
        static func urlWith(type: TopHeadlines, append: String) -> String {
            return "\(type.rawValue)\(append)"
        }
        
        func url () -> String {
            return APIUrl.TopHeadlines.urlWith(type: self, append: "")
        }
    }
    
    enum Everything: String {
        case everything = "/everything"
        
        static func urlWith(type: Everything, append: String) -> String {
            return "\(type.rawValue)\(append)"
        }
        
        func url() -> String {
            return APIUrl.Everything.urlWith(type: self, append: "")
        }
    }
}

enum HTTPMethod: String {
    case get
    case post
}
