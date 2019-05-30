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
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Giphy"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
        return searchResults.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let cell = cell as? GiphyCollectionViewCelll {
            let giphy = searchResults[indexPath.row]
            cell.imageView.sd_setImage(with: giphy.url)
            cell.imageView.backgroundColor = .red
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let shoudLoadNextPage
    }
    
    func search(for text: String?) {
        if let text = text,
            !text.isEmpty {
            SDWebImageManager.shared.cancelAll()
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
//            searchResults = []
        }
        collectionView.reloadData()
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
        search(for: searchController.searchBar.text)
    }
    
}
