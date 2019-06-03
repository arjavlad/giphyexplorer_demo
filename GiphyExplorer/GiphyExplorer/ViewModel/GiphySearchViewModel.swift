//
//  GiphySearchViewModel.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 02/06/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import Foundation

protocol GiphySearchViewModelDelegate {
    func giphyLoaded(for indexPaths: [IndexPath]?)
    func giphyFetchFailed(with error: String)
}

final class GiphySearchViewModel {
    
    private var searchResults: [Giphy] = []
    private var currentPage: Int = 0
    private var total: Int = 0
    private var isLoadingData: Bool = false
    private let client: GiphySearchClient = GiphySearchClient()
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return searchResults.count
    }
    
    private var nextPage: Int {
        return currentPage + 1
    }
    
    private var request: GiphySearchRequest
    private let delegate: GiphySearchViewModelDelegate
    
    init(with request: GiphySearchRequest, delegate: GiphySearchViewModelDelegate) {
        self.delegate = delegate
        self.request = request
    }
    
    func giphy(at index: Int) -> Giphy {
        return searchResults[index]
    }
    
    func set(request new: GiphySearchRequest) {
        request = new
        currentPage = 0
        total = 0
        searchResults = []
        delegate.giphyLoaded(for: .none)
    }
    
    /// Fetches Giphy with text query
    func fetchGiphy() {
        if isLoadingData {
            return
        }
        
        isLoadingData = true
        client.fetch(with: request, page: nextPage) { (result) in
            self.isLoadingData = false
            switch result {
            case .success(let response):
                self.total = response.pagination.totalCount
                self.checkDuplicates(for: response.data)
                self.searchResults.append(contentsOf: response.data)
                self.currentPage += 1
                if response.pagination.offset - 20 > 1 {
                    let newIndexPaths = self.indexPathsToReload(for: response.data)
                    self.delegate.giphyLoaded(for: newIndexPaths)
                } else {
                    self.delegate.giphyLoaded(for: .none)
                }
                
            case .failure(let error):
                self.delegate.giphyFetchFailed(with: error.description)
            }
        }
    }
    
    private func indexPathsToReload(for newGiphy: [Giphy]) -> [IndexPath] {
        let startIndex = currentCount - newGiphy.count
        let endIndex = startIndex + newGiphy.count
        return (startIndex..<endIndex).map { IndexPath.init(item: $0, section: 0) }
    }
    
    /// This is not useful in anyway in the production mode. This is for debugging and finding if there are any dulicate Giphy in new response.
    ///
    /// - Parameter new:
    private func checkDuplicates(for new: [Giphy]) {
        var originalURLs = searchResults.compactMap { $0.url }
        let newURLs = new.compactMap { $0.url }
        let duplicates = Set.init(originalURLs).intersection(newURLs)
        print("Found \(duplicates.count) duplicates!")
        originalURLs.append(contentsOf: newURLs)
        let allURLs = Set.init(originalURLs)
        print("Count: \(allURLs.count)\nAll urls: \(Array(allURLs))")
    }
}
