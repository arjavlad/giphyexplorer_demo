//
//  GiphyExplorerCollectionViewController.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "GiphyCollectionViewCell"
private let GiphyCollectionViewCell_XIB_Name = "GiphyCollectionViewCell"

final class GiphyExplorerCollectionViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    
    private let searchController = UISearchController.init(searchResultsController: nil)
    private var viewModel: GiphySearchViewModel!
    private var searchDelayTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        clearsSelectionOnViewWillAppear = true
        
        // Register cell classes
        collectionView.register(UINib.init(nibName: GiphyCollectionViewCell_XIB_Name, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.prefetchDataSource = self
        
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
        guard let giphyCell = cell as? GiphyCollectionViewCell else {
            return cell
        }
        let giphy = isLoadingCell(for: indexPath) ? nil : viewModel.giphy(at: indexPath.item)
        giphyCell.configure(with: giphy)
        return giphyCell
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
        // TODO: Move these strings at the top of the file
        let alertController = UIAlertController.init(title: "Error!", message: error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension GiphyExplorerCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchDelayTimer?.invalidate()
        searchDelayTimer = nil
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(searchDelayTimerInvoked(_:)), userInfo: nil, repeats: false)
    }
}
