//
//  ViewController.swift
//  DemoTest
//
//  Created by Sahil Garg on 21/07/22.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var heightConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var pageControlView: UIPageControl!
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        scrollView.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
        searchBarView.placeholder = "Search"
        self.loadDataFromAPI()
        
    }
    
    func reloadView() {
        self.tableView.reloadData()
        self.imagesCollectionView.reloadData()
        self.pageControlView.numberOfPages = self.viewModel.tempAnimeList.count
        scrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height + 250)
        self.perform(#selector(setTableHeightDynamically), with: nil, afterDelay: 0.4)
    }
    
    // Set table height after getting its content for default basic delay
    @objc func setTableHeightDynamically() {
        self.heightConstraintTableView.constant = self.view.frame.size.height - 150
    }
    
}

// MARK: UITableView DataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tempAnimeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as? TableViewCell else {
            return UITableViewCell()
        }
        cell.cellItem = viewModel.tempAnimeList[indexPath.row]
        viewModel.loadImage(index: indexPath.row) { image in
            cell.flagImageView.image = image
        }
        return cell
    }
    
}

// MARK: UIScrollView Delegate
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(imagesCollectionView.contentOffset.x/imagesCollectionView.frame.width)
        pageControlView.currentPage = Int(pageIndex)
        if scrollView == self.scrollView && scrollView != tableView {
            if scrollView.contentOffset.y > 150 {
                self.tableView.isScrollEnabled = true
            } else {
                self.tableView.isScrollEnabled = false
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = round(imagesCollectionView.contentOffset.x/imagesCollectionView.frame.width)
        tableView.scrollToRow(at: IndexPath(row: Int(index), section: 0), at: .top, animated: true)
    }
}

// MARK: UICollectionView DataSource, UICollectionView Delegate, UICollectionView DelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tempAnimeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCellIdentifier", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        viewModel.loadImage(index: indexPath.row) { image in
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
}

// MARK: UISearchBar Delegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let searchBarText = searchBar.text {
            if searchBarText.isEmpty {
                viewModel.tempAnimeList = viewModel.animeList
            } else {
                viewModel.tempAnimeList = viewModel.animeList.filter({ $0.title.localizedCaseInsensitiveContains(searchBarText)
                })
            }
        }
        self.reloadView()
    }
    
}

// MARK: API
extension ViewController {
    
    func loadDataFromAPI() {
        viewModel.getDataFromAPI { status, message in
            DispatchQueue.main.async {
                self.reloadView()
            }
        }
    }
}
