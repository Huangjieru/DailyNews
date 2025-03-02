//
//  NewsManager.swift
//  DailyNews
//
//  Created by JRU on 2025/3/2.
//

import UIKit

class NewsManager {
    
    static let shared = NewsManager()
    //產生 NSCache 物件。以key找對應的value。<>裡傳入key, value。key的型別是NSURL, value的型別是UIImage。
    let imageCache = NSCache<NSURL, UIImage>()
    //NSCache 要求它的 key & value 的型別都必須是物件，因此只能傳入 class 定義的型別，而 URL 是 struct。
    //NSCache 比較不會造成記憶體的問題，因為當系統記憶體不夠時，它會自動將東西從 cache 裡移除
    
    //畫面出現時呈現的新聞
    func fetchItems(completion: @escaping ([NewsResponse.Article]?)->Void){
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=60ee7c4a0986431ba48c8d9f5a9efa4f"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil)
            }else if let data = data{
                do{
                    let decoder = JSONDecoder()
                    let news = try decoder.decode(NewsResponse.self, from: data)
                    completion(news.articles)
                }catch{
                    print(error)
                    completion(nil)
                }
            }
        }.resume()
    }
    //抓取新聞圖片
    func fetchImage(from url: URL, completion: @escaping (UIImage?)->Void){
        //當 cache 有圖時，直接讀取 cache 裡的圖片
        if let image = imageCache.object(forKey: url as NSURL){
            print("抓Cache圖片")
            completion(image)
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completion(nil)
            }else if let data = data, let image = UIImage(data: data){
                //從網路抓圖後，將圖片存入 cache。setObject(_:forKey:)，將圖片存入 cache
                self.imageCache.setObject(image, forKey: url as NSURL) //在產生 imageCache 設定時是 NSURL，所以在此要做型別的轉換，將url利用 as 轉成 NSURL。
                
                completion(image)
            }else{
                completion(nil)
            }
        }.resume()
    }
    //搜尋新聞的API
    func fetchSearchNews(text:String, completion: @escaping ([NewsResponse.Article]?)->Void){
        let urlString = "https://newsapi.org/v2/everything?apiKey=60ee7c4a0986431ba48c8d9f5a9efa4f&searchIn=title&q=\(text)"
        guard let url = URL(string: urlString)  else { return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data{
                do{
                   let deocoder = JSONDecoder()
                    let news = try deocoder.decode(NewsResponse.self, from: data)
                    completion(news.articles)
                }catch{
                    print(error)
                }
            }
        }.resume()
    }
    
}
