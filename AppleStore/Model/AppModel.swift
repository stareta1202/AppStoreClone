//
//  AppModel.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/18.
//

import Foundation


struct AppResponse: Decodable {
    var resultCount: Int
    var results: [AppModel]
}
struct AppModel: Decodable {
    var name: String
    var genre: String
    var icon: String
    var screenshots: [String]
    var minimumOsVersion: String
    var supportedLanguages: [String]
    var fileSizeBytes: String
    var formattedPrice: String
    var contentAdvisoryRating: String
    var averageUserRating: Double
    var currentVersionReleaseDate: String
    var sellerName: String
    var releaseNotes: String
    var appVersion: String
    var currency: String
    var price: Double
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case minimumOsVersion,
             fileSizeBytes,
             formattedPrice,
             contentAdvisoryRating,
             averageUserRating,
             currentVersionReleaseDate,
             sellerName,
             releaseNotes,
             currency,
             price,
             description
        case name = "trackName"
        case genre = "primaryGenreName"
        case icon = "artworkUrl512"
        case screenshots = "screenshotUrls"
        case supportedLangauges = "languageCodesISO2A"
        case appVersion = "version"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.minimumOsVersion = try values.decode(String.self, forKey: .minimumOsVersion)
        self.fileSizeBytes = try values.decode(String.self, forKey: .fileSizeBytes)
        self.formattedPrice = try values.decode(String.self, forKey: .formattedPrice)
        self.contentAdvisoryRating = try values.decode(String.self, forKey: .contentAdvisoryRating)
        self.averageUserRating = try values.decode(Double.self, forKey: .averageUserRating)
        self.currentVersionReleaseDate = try values.decode(String.self, forKey: .currentVersionReleaseDate)
        self.sellerName = try values.decode(String.self, forKey: .sellerName)
        self.releaseNotes = try values.decode(String.self, forKey: .releaseNotes)
        self.currency = try values.decode(String.self, forKey: .currency)
        self.price = try values.decode(Double.self, forKey: .price)
        self.description = try values.decode(String.self, forKey: .description)
        self.name = try values.decode(String.self, forKey: .name)
        self.genre = try values.decode(String.self, forKey: .genre)
        self.icon = try values.decode(String.self, forKey: .icon)
        self.screenshots = try values.decode([String].self, forKey: .screenshots)
        self.supportedLanguages = try values.decode([String].self, forKey: .supportedLangauges)
        self.appVersion = try values.decode(String.self, forKey: .appVersion)
    }
}
