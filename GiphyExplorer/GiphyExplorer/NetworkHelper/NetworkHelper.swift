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
    static func prepareGET(request: NetworkRequest, with additionalParam: [String: String]? = nil) -> URLRequest? {
        var urlComps = URLComponents.init(url: GiphyBaseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem]()
        var params = request.params
        if let otherParams = additionalParam {
            otherParams.forEach { (key, value) in
                params[key] = value
            }
        }
        params["api_key"] = GiphyApiKey
        params.forEach { (key, value) in
            queryItems.append(URLQueryItem.init(name: key, value: value))
        }
        urlComps?.queryItems = queryItems
        guard let fullURL = urlComps?.url else {
            assertionFailure()
            return nil
        }
        return URLRequest.init(url: fullURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
    }
}
