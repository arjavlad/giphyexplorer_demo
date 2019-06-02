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
    
    private let searchController = UISearchController.init(searchResultsController: nil)
    private var viewModel: GiphySearchViewModel!
    private var searchDelayTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        // Register cell classes
        self.collectionView.register(UINib.init(nibName: "GiphyCollectionViewCelll", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.prefetchDataSource = self
        
        // Do any additional setup after loading the view.
        viewModel = GiphySearchViewModel.init(with: GiphySearchRequest.init(with: ""), delegate: self)
        setupSearchBar()
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
        return viewModel.totalCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let cell = cell as? GiphyCollectionViewCelll {
            if isLoadingCell(for: indexPath) {
                cell.configure(with: nil)
            } else {
                cell.configure(with: viewModel.giphy(at: indexPath.item))
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchGiphy()
        }
    }
    
    
    /// Setup SearchController and SearchBar
    func setupSearchBar() {
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Giphy"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    /// To check whether the Giphy is loaded for cell or not
    ///
    /// - Parameter indexPath: indexPath of cell
    /// - Returns: whether the cell is prefetched or not
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= viewModel.currentCount
    }
    
    /// Calculates indexpaths to reload in case of prefetching
    ///
    /// - Parameter indexPaths: Indexpaths of new fetched Giphys
    /// - Returns: return only visible and newly fetched indexes
    func indexPathsToReload(_ indexPaths: [IndexPath]) -> [IndexPath] {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let indexPathsToReload = Set(visibleIndexPaths).intersection(indexPaths)
        return Array(indexPathsToReload)
    }
    
    
    /// Searches Giphy with given text query
    ///
    /// - Parameter text: Query text
    func search(for text: String) {
        print("Searching for \(text)")
        viewModel.set(request: GiphySearchRequest.init(with: text))
        viewModel.fetchGiphy()
    }
    
    /// Invoked by a delay timer which allows user to enter full text before it triggers search call.
    /// Default delay time is 2 seconds.
    ///
    /// - Parameter timer: timer
    @objc func searchDelayTimerInvoked(_ timer: Timer) {
        search(for: searchController.searchBar.text ?? "")
    }
}

extension GiphyExplorerCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 2
        return CGSize.init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 5, bottom: 10, right: 5)
    }
}

extension GiphyExplorerCollectionViewController: GiphySearchViewModelDelegate {
    func giphyLoaded(for indexPaths: [IndexPath]?) {
        if let indexPaths = indexPaths {
            collectionView.reloadItems(at: indexPaths)
        } else {
            collectionView.reloadData()
        }
    }
    
    func giphyFetchFailed(with error: String) {
        let alertController = UIAlertController.init(title: "Error!", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension GiphyExplorerCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchDelayTimer?.invalidate()
        searchDelayTimer = nil
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(searchDelayTimerInvoked(_:)), userInfo: nil, repeats: false)
    }
}
