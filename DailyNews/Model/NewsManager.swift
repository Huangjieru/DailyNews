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
    
    func managers<T: Decodable> (object: T.Type, method: HTTPMethod, appendUrl: String = "", apiUrl: APIUrl, parameters: [String: String]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        
        let encoderUrl = appendUrl
        var requestUrl = ""
        switch apiUrl {
        case .topHeadlines(let type):
            requestUrl = type.url()
        case .everything(let type):
            requestUrl = type.url()
        }
        requestUrl =  (requestUrl + encoderUrl ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        var newParameter = parameters ?? [:]
        newParameter["apiKey"] = "60ee7c4a0986431ba48c8d9f5a9efa4f"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2\(requestUrl)"
        urlComponents.queryItems = newParameter.map({ para in
            URLQueryItem(name: para.key, value: para.value)
        })
        
        guard let url = urlComponents.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("------------[失敗]---------------")
                print("The Request URL: \(url)")
                print("parameters: \(newParameter)")
                print(error)
                completion(.failure(error))
            }else if let data = data{
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: data)
                    print("----------[成功]-------------")
                    print("The_requestUrl : \(url)")
                    print("parameters: \(newParameter)")
                    print(self.getPrettyPrinJson(data))
                    completion(.success(response))
                }
                catch {
                    print("-------------[失敗]--------------")
                    print("The Request URL: \(url)")
                    print("parameters: \(newParameter)")
                    let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    print(jsonData as Any)
                    completion(.failure(error))
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
}

extension NewsManager {
    
    private func getPrettyPrinJson(_ responseValue: Any) -> String {
        var string: String = ""
        if let json = try? JSONSerialization.jsonObject(with: responseValue as! Data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8){
            string = jsonString
        }else {
            print("json data malformed")
        }
        return string
    }
}
