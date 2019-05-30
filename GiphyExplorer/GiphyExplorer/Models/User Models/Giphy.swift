//
//  Giphy.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import Foundation

struct Giphy: Codable {
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case pageURL = "url"
        case title = "title"
        case images = "images"
    }
    
    let type: String
    let id: String
    let pageURL: URL
    let title: String
    private let images: GiphyOriginalImageData
    var url: URL {
        return images.fixed_height_small.url
    }
}

fileprivate struct GiphyOriginalImageData: Codable {
    let fixed_height_small: GiphyImageURL
}

fileprivate struct GiphyImageURL: Codable {
    let url: URL
}
