//
//  RecentSearchModel.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/18.
//

import Foundation
import RealmSwift

class RecentSearchModelCollection: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var recentSearchModels = List<RecentSearchModel>()
}

class RecentSearchModel: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted(indexed: true) var title: String = ""
}
