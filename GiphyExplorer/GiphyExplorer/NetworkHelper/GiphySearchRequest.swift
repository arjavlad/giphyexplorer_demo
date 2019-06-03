//
//  GiphySearchRequest.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 01/06/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import Foundation

struct GiphySearchRequest: NetworkRequest {
    var path: String = "search"
    let query: String
    var params: [String: String] {
        return [
            "q": query,
            "limit": "20",
            "rating": "G",
            "lang": "en"
        ]
    }
    
    init(with query: String) {
        self.query = query
    }
}

struct GiphySearchClient {
    let session: URLSession
    
    init(with session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch(with request: GiphySearchRequest, page: Int, _ completion: @escaping (Result<GiphyResponse, GiphyResponseError>) -> ()) {
        let offset = page < 1 ? page : page + 20
        let pageParam = ["offset": "\(offset)"]
        guard let callRequest = NetworkHelper.prepareGET(request: request, with: pageParam) else {
            completion(Result.failure(.network))
            assertionFailure()
            return
        }
        print("Searching for \(request.query) on page \(page)")
        print("++++++++++++++++++++++++++++++++++++++++")
        print("Calling API: \(String(describing: callRequest.url?.absoluteString))")
        session.dataTask(with: callRequest) { (responseData, response, requestError) in
            print("call complete for: \(String(describing: callRequest.url?.absoluteString))")
            print("++++++++++++++++++++++++++++++++++++++++")
            DispatchQueue.main.async {
                guard let responseData = responseData else {
                    print("Network Error: \(requestError?.localizedDescription ?? "not found")")
                    completion(Result.failure(.network))
                    return
                }
                let decoder = JSONDecoder.init()
                do {
                    let decodedResponse = try decoder.decode(GiphyResponse.self, from: responseData)
                    print("Loaded: \(decodedResponse.data.count) Giphy")
                    completion(Result.success(decodedResponse))
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    let rawString = String.init(data: responseData, encoding: .utf8)
                    print("Raw response for: \(String(describing: response?.url?.absoluteString))")
                    print("+++========================+++++++++++++++++++++==============================+++++++++++++++++++++")
                    print(rawString ?? "nil")
                    print("+++========================+++++++++++++++++++++==============================+++++++++++++++++++++")
                    completion(Result.failure(.decode))
                }
            }
            }.resume()
    }
}
