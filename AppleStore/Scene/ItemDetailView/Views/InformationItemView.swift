//
//  InformationItemView.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/21.
//

import Foundation
import UIKit

extension ItemDetailViewController {
    class InformationItemView: UIView {
        
        private let leftLabel = UILabel()
        private let rightLabel = UILabel()
        
        init(left: String , right: String) {
            super.init(frame: .zero)
            initView()
            setupView(left: left, right: right)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initView() {
            self.add(VStackView([
                VSpaceView(20),
                HStackView([
                    leftLabel,
                    UIView(),
                    rightLabel
                ]),
                VSpaceView(20),
            ])) {
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        
        private func setupView(left: String, right: String) {
            leftLabel.text = left
            leftLabel.textColor = .lightGray
            rightLabel.text = right
        }
    }
}

