//
//  SearchViewController.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/17.
//

import Foundation
import UIKit
import AddThen
import Combine
import SnapKit
import RealmSwift

class SearchViewController: UIViewController {
    private var subscription: Set<AnyCancellable> = .init()
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let core = SearchViewCore()
    private var researchModels: [RecentSearchModel] = []
    private var filteredResearchModels: [RecentSearchModel] = []
    private var appModels: [AppModel] = []
    
    private var isFiltering: Bool {
        guard let searchCon = self.navigationItem.searchController else { return false }
        let isActive = searchCon.isActive
        let isSearchBarHasText = searchCon.searchBar.text?.isEmpty == false
        return (isActive && isSearchBarHasText)
    }
    
    private var layoutType: LayoutType = .recent {
        didSet{ changeView() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bind(core: core)
    }
    
    private func initView() {
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        view.add(tableView) { [unowned self] in
            $0.delegate = self
            $0.dataSource = self
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            $0.register(SearchRecentTableViewCell.self, forCellReuseIdentifier: SearchRecentTableViewCell.identifier)
        }
    }
    
    private func setupCollectionView() {
        view.add(collectionView) { [unowned self] in
            $0.delegate = self
            $0.dataSource = self
            let refreshController = UIRefreshControl()
            refreshController.addTarget(self, action: #selector(self.refreshPhotos), for: .valueChanged)
            $0.refreshControl = refreshController
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            $0.prefetchDataSource = self
            $0.register(AppCollectionViewCell.self, forCellWithReuseIdentifier: AppCollectionViewCell.identifier)
        }
    }
    
    private func setupSearchBar() {
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "??????, ???, ????????? ???"
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "??????"
    }
    
    private func changeView() {
        switch layoutType {
        case .recent:
            collectionView.removeFromSuperview()
            setupTableView()
        case .result:
            tableView.removeFromSuperview()
            setupCollectionView()
        }
    }
    @objc private func refreshPhotos() {
        core.next()
    }
}

// MARK: Binding
extension SearchViewController {
    func bind(core: SearchViewCore) {
        core.$recentSearchModels
            .sink { [weak self] researchModels in
                guard let self = self else { return }
                self.researchModels = researchModels
                self.tableView.reloadData()
            }
            .store(in: &subscription)
        
        core.$appModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] appModels in
                self?.appModels = appModels
                self?.collectionView.reloadData()
            }
            .store(in: &subscription)
    }
}

// MARK: UITableView DataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredResearchModels.count : researchModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchRecentTableViewCell.identifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = isFiltering ? filteredResearchModels[indexPath.row].title : researchModels[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }
}
// MARK: UITableView Delegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = isFiltering ? filteredResearchModels[indexPath.row].title : researchModels[indexPath.row].title
        searchController.searchBar.text = text
        searchController.isActive = true
        searchController.searchBar.resignFirstResponder()
        core.add(text)
        layoutType = .result
    }
}

// MARK: UICollectionView DataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: AppCollectionViewCell.identifier, for: indexPath) as? AppCollectionViewCell) else { return UICollectionViewCell() }
        cell.configure(self.core.appModels[indexPath.row])

        return cell
    }


}
// MARK: UICollectionView Delegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ItemDetailViewController.instantiate(with: self.core.appModels[indexPath.row]), animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let cellHeight = cellWidth * 0.9
        return CGSize(width: cellWidth, height: cellHeight)
    }

}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if core.appModels.count == 0 { return }
        guard let row = indexPaths.first?.row else { return }
        if  row == core.appModels.count - 1 {
            core.next()
        }
    }
}

// MARK: UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        layoutType = .recent
        filteredResearchModels = researchModels.filter({
            $0.title.localizedStandardContains(text) == true
        })
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        layoutType = .recent
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty, text.trimmingCharacters(in: .whitespaces) != "" {
            core.add(text)
            layoutType = .result
        }
    }
}

fileprivate enum LayoutType {
    case recent
    case result
}
