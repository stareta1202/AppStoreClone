//
//  ErrorFactory.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/17.
//

import Foundation

protocol ErrorFactory {
  static var domain: String { get }
  associatedtype Code: RawRepresentable where Code.RawValue == Int
}

extension ErrorFactory {
  static var domain: String { "\(Self.self)" }
}
