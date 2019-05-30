//
//  GiphyExplorerCollectionViewController.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GiphyCollectionViewCelll"

class GiphyExplorerCollectionViewController: UICollectionViewController {
    
    let searchController = UISearchController.init(searchResultsController: nil)
    var searchResults: [Giphy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Register cell classes
        self.collectionView.register(UINib.init(nibName: "GiphyCollectionViewCelll", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Giphy"
        navigationItem.searchController = searchController
        searchController.becomeFirstResponder()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let cell = cell as? GiphyCollectionViewCelll {
            let giphy = searchResults[indexPath.row]
            cell.imageView.sd_setImage(with: giphy.url)
        }
    
        return cell
    }
    
    func search(for text: String?) {
        if let text = text,
            !text.isEmpty {
            NetworkManager.shared.search(giphy: text, page: 0) { (results, error) in
                if let error = error {
                    self.searchResults = []
                    print("Found Error while searching: \(error.localizedDescription)")
                } else {
                    self.searchResults = results
                }
                self.collectionView.reloadData()
            }
        } else {
            searchResults = []
        }
        collectionView.reloadData()
    }
}

extension GiphyExplorerCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        search(for: searchController.searchBar.text)
    }
    
}
