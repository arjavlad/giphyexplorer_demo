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
    let page: Int
    
    var params: [String: String] {
        return [
            "q": query,
            "limit": "20",
            "offset": "\(page + 20)",
            "rating": "G",
            "lang": "en"
        ]
    }
}

struct GiphySearchClient {
    let session: URLSession
    
    func fetch(with request: GiphySearchRequest, _ completion: @escaping (Result<GiphyResponse, GiphyResponseError>) -> ()) {
        guard let callRequest = NetworkHelper.prepareGET(request: request) else {
            completion(Result.failure(.network))
            assertionFailure()
            return
        }
        print("++++++++++++++++++++++++++++++++++++++++")
        print("Calling API: \(String(describing: callRequest.url?.absoluteString))")
        session.dataTask(with: callRequest) { (responseData, response, requestError) in
            print("call complete for: \(String(describing: callRequest.url?.absoluteString))")
            print("++++++++++++++++++++++++++++++++++++++++")
            DispatchQueue.main.async {
                if let responseData = responseData {
                    let decoder = JSONDecoder.init()
                    do {
                        let decodedResponse = try decoder.decode(GiphyResponse.self, from: responseData)
                        completion(Result.success(decodedResponse))
                    } catch {
                        print("Decoding Error: \(error.localizedDescription)")
                        completion(Result.failure(GiphyResponseError.decode))
                    }
                } else {
                    print("Netowork Error: \(requestError?.localizedDescription ?? "not found")")
                    completion(Result.failure(GiphyResponseError.network))
                }
            }
            }.resume()
    }
}
