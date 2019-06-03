//
//  NetworkHelper.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import Foundation


/// These are extra keys incase any key reaches it's limit.
//let GiphyApiKey: String = "Ya57VGpf7D2pw5N08o9TiOCPiThSnsfI"
//let GiphyApiKey: String = "dGfGX0EBAP8m8NVrXP3W91djS0Q1KoHu"

private let GiphyApiKey: String = "mFo9m1VQAAloN6GYeOWBoxv2fxior6WS"
private let GiphyBaseURL: URL = URL.init(string: "https://api.giphy.com/v1/gifs")!

protocol NetworkRequest {
    var path: String { get }
    var params: [String: String] { get }
}

struct NetworkHelper {
    static func prepareGET(request: NetworkRequest, with additionalParam: [String: String]? = nil) -> URLRequest? {
        var urlComps = URLComponents.init(url: GiphyBaseURL.appendingPathComponent(request.path), resolvingAgainstBaseURL: false)
        var params = request.params
        additionalParam?.forEach({ params[$0] = $1 })
        params["api_key"] = GiphyApiKey
        urlComps?.queryItems = params.map({ return URLQueryItem(name: $0, value: $1) })
        guard let fullURL = urlComps?.url else {
            assertionFailure()
            return nil
        }
        return URLRequest.init(url: fullURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
    }
}
