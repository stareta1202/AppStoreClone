//
//  ImageCacheService.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/20.
//

import Foundation
import UIKit

class ImageCacheService {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
