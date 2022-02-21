//
//  UIVIew+Extension.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/21.
//

import Foundation
import UIKit

class VSpaceView: UIView {
    init(_ space: CGFloat) {
        super.init(frame: .zero)
        self.snp.makeConstraints { make in
            make.height.equalTo(space)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HSpaceView: UIView {
    init(_ space: CGFloat) {
        super.init(frame: .zero)
        self.snp.makeConstraints { make in
            make.width.equalTo(space)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VStackView: UIStackView {
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(_ views: [UIView]) {
        self.init()
        views.forEach({
            self.addArrangedSubview($0)
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HStackView: UIStackView {
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(_ views: [UIView]) {
        self.init()
        views.forEach({
            self.addArrangedSubview($0)
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
