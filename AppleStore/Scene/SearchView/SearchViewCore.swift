//
//  SearchViewCore.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/17.
//

import Foundation
import Combine
import RealmSwift

class SearchViewCore: ObservableObject {
    private var subscription = Set<AnyCancellable>()
    private let realm: Realm = try! Realm()
    private var recentSearchModelCollection: RecentSearchModelCollection!
    private var token: NotificationToken?
    @Published var researchModels: [RecentSearchModel] = []
    @Published var filteredResearcheModels: [RecentSearchModel] = []
    @Published var appModels: [AppModel] = []
    var searchedText$ = CurrentValueSubject<String, Never>("")
    private let searchService = AppleStoreSearchService.shared
    
    init() {
        loadInitialData()
        setupObserve()
    }
    
    deinit {
        token?.invalidate()
        token = nil
    }
    
    func add(_ searchText: String) {
        searchService.getList(searchText)
            .map({ $0.results })
            .replaceError(with: [])
            .assign(to: \.appModels, on: self)
            .store(in: &subscription)
        
        try? realm.write({
            let model = RecentSearchModel()
            model.title = searchText
            if !recentSearchModelCollection.recentSearchModels.contains(where: { model in
                return model.title == searchText
            }) {
                recentSearchModelCollection.recentSearchModels.append(model)
                realm.add(model, update: .modified)
            }
        })
    }
    
    private func loadInitialData() {
        if(realm.objects(RecentSearchModelCollection.self).first == nil) {
            try? realm.write { [weak self] in
                guard let self = self else { return }
                self.recentSearchModelCollection = .init()
                realm.add(self.recentSearchModelCollection)
            }
        } else {
            recentSearchModelCollection = realm.objects(RecentSearchModelCollection.self).first
            researchModels = Array(recentSearchModelCollection.recentSearchModels)
        }
    }
    
    private func setupObserve() {
        let token = realm.observe { [weak self] _, realm in
            guard let self = self else { return }
            if let recentSearchs = realm.objects(RecentSearchModelCollection.self).first?.recentSearchModels {
                self.researchModels = Array(recentSearchs)
            }
        }
        self.token = token
    }
}
