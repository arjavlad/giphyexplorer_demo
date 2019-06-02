//
//  GiphyExplorerCollectionViewController.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "GiphyCollectionViewCelll"

class GiphyExplorerCollectionViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    
    let searchController = UISearchController.init(searchResultsController: nil)
    var searchResults: [Giphy] = []
    var currentPage: Int = 0
    let maxPage = 1
    var searchKeyword: String {
        let text = searchController.searchBar.text ?? "iOS"
        return text.isEmpty ? "ios" : text
    }
    var totalCount: Int = 0
    var currentCount: Int {
        return searchResults.count
    }
    var isLoadingData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Register cell classes
        self.collectionView.register(UINib.init(nibName: "GiphyCollectionViewCelll", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.prefetchDataSource = self
        
        // Do any additional setup after loading the view.
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Giphy"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        search(for: searchKeyword, on: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let cell = cell as? GiphyCollectionViewCelll {
            if !isLoadingCell(for: indexPath) {
                cell.configure(with: searchResults[indexPath.row])
            } else {
                cell.configure(with: nil)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            loadNextPage()
        }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= currentCount
    }
    
    func indexPathsToReload(_ indexPaths: [IndexPath]) -> [IndexPath] {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let indexPathsToReload = Set(visibleIndexPaths).intersection(indexPaths)
        return Array(indexPathsToReload)
    }
    
    func loadNextPage() {
        
        // We have to set  max pag limittation due to Giphy API's limit for Dev environment
        let nextpage = currentPage < maxPage ? currentPage + 1 : currentPage
        print("Current page: \(currentPage)")
        print("Next page: \(nextpage)")
        search(for: searchKeyword, on: nextpage)
    }
    
    func search(for text: String, on page: Int) {
        if isLoadingData {
            return
        }
        isLoadingData = true
//        NetworkManager.shared.search(giphy: text, page: page) { (results, totalCount, error) in
//            print("Loaded for page: \(page)")
//            self.isLoadingData = false
//            if let error = error {
//                print("Found Error while searching: \(error.localizedDescription)")
//            } else {
//                self.totalCount = totalCount
//                self.currentPage = page
//                self.searchResults.append(contentsOf: results)
//                print("Total count: \(totalCount)")
//            }
//            self.collectionView.reloadData()
//        }
    }
}

extension GiphyExplorerCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 2
        return CGSize.init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 5, bottom: 10, right: 5)
    }
}

extension GiphyExplorerCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        currentPage = 0
        SDWebImageManager.shared.cancelAll()
        search(for: searchKeyword, on: currentPage)
    }
    
}
