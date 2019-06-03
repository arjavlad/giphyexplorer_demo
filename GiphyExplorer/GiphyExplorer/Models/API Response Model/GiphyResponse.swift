//
//  GiphyResponse.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import Foundation

struct GiphyResponse: Codable {
    let data: [Giphy]
    let pagination: GiphyResponsePagination
    let meta: GiphyResponseMeta
}

struct GiphyResponsePagination: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
    let totalCount: Int
    let count: Int
    let offset: Int
}

struct GiphyResponseMeta: Codable {
    private enum CodingKeys: String, CodingKey {
        case status
        case message = "msg"
        case responseID = "response_id"
    }
    let status: Double
    let message: String
    let responseID: String
}
