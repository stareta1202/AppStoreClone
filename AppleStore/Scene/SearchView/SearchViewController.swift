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
    private var subscription = Set<AnyCancellable>()
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let core = SearchViewCore()
    private var researchModels: [RecentSearchModel] = []
    private var filteredResearchModels: [RecentSearchModel] = []
    private var isFiltering: Bool {
        guard let searchCon = self.navigationItem.searchController else { return false }
        let isActive = searchCon.isActive
        let isSearchBarHasText = searchCon.searchBar.text?.isEmpty == false
        return (isActive && isSearchBarHasText)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSTemporaryDirectory())
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
    
    private func setupSearchBar() {
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.isActive = true
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "검색"
    }
}

// MARK: Binding
extension SearchViewController {
    func bind(core: SearchViewCore) {
        core.$researchModels.sink { [weak self] researchModels in
            guard let self = self else { return }
            self.researchModels = researchModels
            self.tableView.reloadData()
        }
        .store(in: &subscription)
        
        core.$appModels.sink { appModels in
            print("🐱 \(appModels)")
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
}

// MARK: UISearchResultsUpdating &
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        filteredResearchModels = researchModels.filter({
            $0.title.localizedStandardContains(text) == true
        })
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty, text.trimmingCharacters(in: .whitespaces) != "" {
            core.add(text)
            tableView.reloadData()
        }
    }
}
