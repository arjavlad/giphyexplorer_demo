//
//  NetworkManager.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func callGET(api path: String,
                 params: [String: Any],
                 addAPIKey: Bool = true,
                 _ completion: @escaping (GiphyResponse?, Error?) -> ()) {
        var urlComps = URLComponents.init(url: GiphyBaseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem.init(name: key, value: "\(value)"))
        }
        if addAPIKey {
            queryItems.append(URLQueryItem.init(name: "api_key", value: GiphyApiKey))
        }
        urlComps?.queryItems = queryItems
        guard let fullURL = urlComps?.url else {
            completion(nil, NSError.init(domain: "com.app.urlinvalid",
                                         code: 422,
                                         userInfo: [
                                            NSLocalizedDescriptionKey: "Unable process this request!"
                ]
            ))
            assertionFailure()
            return
        }
        print("++++++++++++++++++++++++++++++++++++++++")
        print("Calling API: \(fullURL.absoluteString)")
        let request = URLRequest.init(url: fullURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
        let session = URLSession.shared
        session.invalidateAndCancel()
        session.dataTask(with: request) { (responseData, response, requestError) in
            print("call complete for: \(fullURL.absoluteString)")
            print("++++++++++++++++++++++++++++++++++++++++")
            if let responseData = responseData {
                let decoder = JSONDecoder.init()
                do {
                    let decodedResponse = try decoder.decode(GiphyResponse.self, from: responseData)
                    completion(decodedResponse, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, requestError)
            }
            }.resume()
    }
}

extension NetworkManager {
    func search(giphy keyword: String, page: Int, _ completion: @escaping ([Giphy], Error?) -> ()) {
        let params: [String : Any] = [
            "q": keyword,
            "limit": 20,
            "offset": page,
            "rating": "G",
            "lang": "en"
        ]
        self.callGET(api: "search", params: params) { (response, error) in
            DispatchQueue.main.async {
                completion(response?.data ?? [], error)
            }
        }
    }
}
