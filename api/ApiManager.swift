//
//  ApiManager.swift
//  api
//
//  Created by Keshav Raj Kashyap on 28/01/21.
//

import Foundation

protocol didLoadDelegate {
    func didUpdateCollectionView()
}

var model: ImageModel?
struct ApiManager {
    static var shareInstance = ApiManager()
    
    var delegate: didLoadDelegate?
    
    // MARK:- NETWORKING
    
    func handleApi(query: String, page: Int) {
        let API_KEY = "kutQ6I5P-RcvxF6VqQ1oMad7F15hdGrSVPmutPRbAUw"
        let urlString = "https://api.unsplash.com/search/photos?client_id=\(API_KEY)&page=\(page)&per_page=100&query=\(query)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                //code
                // error
                
                if error != nil {
                    if let err = error {
                        print(err.localizedDescription)
                    }
                }
                
                if let safeData = data {
                    self.parseJSON(safeDa: safeData)
                }
            }
            task.resume()
        }
        
        
    }
    
    // MARK:- DATA DECODE
    func parseJSON(safeDa: Data) {
        let decorder = JSONDecoder()
        do {
            let decode =  try decorder.decode(ImageModel.self, from: safeDa)
            DispatchQueue.main.async {
               model = decode
                delegate?.didUpdateCollectionView()
            }
            
            // adding item here in array
            model?.results.append(contentsOf: decode.results)
//            print(decode.results[0].urls.regular)
        }catch {
            print(error)
        }
        
    }
    
}
