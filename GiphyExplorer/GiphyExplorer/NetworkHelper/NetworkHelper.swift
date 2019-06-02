//
//  NetworkHelper.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    var path: String { get }
    var params: [String: String] { get }
}

struct NetworkHelper {
    static func prepareGET(request: NetworkRequest) -> URLRequest? {
        var urlComps = URLComponents.init(url: GiphyBaseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem]()
        for (key, value) in request.params {
            queryItems.append(URLQueryItem.init(name: key, value: value))
        }
        queryItems.append(URLQueryItem.init(name: "api_key", value: GiphyApiKey))
        urlComps?.queryItems = queryItems
        guard let fullURL = urlComps?.url else {
            assertionFailure()
            return nil
        }
        return URLRequest.init(url: fullURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
    }
}
