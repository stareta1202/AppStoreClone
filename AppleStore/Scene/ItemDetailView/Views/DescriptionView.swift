//
//  DescriptionView.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/21.
//

import Foundation
import UIKit

extension ItemDetailViewController {
    class DescriptionView: UIView {
        private let titleLabel = UILabel()
        private let recordButton = UIButton()
        private let contentLabel = UILabel()
        
        init(_ appModel: AppModel) {
            super.init(frame: .zero)
            initView()
            setupView(appModel)   
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initView() {
            self.add(VStackView([
                HStackView([
                    titleLabel,
                    UIView(),
                ]),
                VSpaceView(16),
                contentLabel
            ])) {
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        
        private func setupView(_ appModel: AppModel) {
            titleLabel.text = "새로운 기능"
            titleLabel.font = .boldSystemFont(ofSize: 24)
            
            contentLabel.numberOfLines = 0
            contentLabel.text = appModel.description
            contentLabel.font = .systemFont(ofSize: 14)
        }
    }
}

