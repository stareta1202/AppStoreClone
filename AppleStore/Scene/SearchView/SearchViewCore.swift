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
    @Published var recentSearchModels: [RecentSearchModel] = []
    @Published var filteredResearcheModels: [RecentSearchModel] = []
    @Published var appModels: [AppModel] = []
    var searchedText$ = CurrentValueSubject<String, Never>("")
    private let searchService = AppleStoreSearchService.shared
    private var limit$ = CurrentValueSubject<Int, Never>(25)

    
    init() {
        loadInitialData()
        setupObserve()
    }
    
    deinit {
        token?.invalidate()
        token = nil
    }
    
    func add(_ searchText: String) {
        limit$
            .flatMap { [weak self] limit -> AnyPublisher<AppResponse, Error> in
                guard let self = self else { return Fail(error: AppleStoreSearchServiceErrorFactory.invalidUrl()).eraseToAnyPublisher() }
                return self.searchService.getList(searchText, limit)
            }
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
            recentSearchModels = Array(recentSearchModelCollection.recentSearchModels)
        }
    }
    
    private func setupObserve() {
        let token = realm.observe { [weak self] _, realm in
            guard let self = self else { return }
            if let recentSearchs = realm.objects(RecentSearchModelCollection.self).first?.recentSearchModels {
                self.recentSearchModels = Array(recentSearchs)
            }
        }
        self.token = token
    }
    
    func next() {
        limit$.send(limit$.value + 10)
    }
}
