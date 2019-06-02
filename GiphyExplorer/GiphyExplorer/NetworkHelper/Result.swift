//
//  Result.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 01/06/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum GiphyResponseError: Error {
    case decode
    case network
    
    var description: String {
        switch self {
        case .decode:
            return "Data received but was in incorect format."
        case .network:
            return "There some network connection error."
        }
    }
}
