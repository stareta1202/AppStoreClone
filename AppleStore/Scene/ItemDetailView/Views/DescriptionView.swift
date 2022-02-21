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
        private let contentView = UIView()
        private let contentLabel = UILabel()
        private let showMoreButton = UIButton()
        private lazy var showMoreAction: UIAction = .init { _ in }
        
        init(_ appModel: AppModel) {
            super.init(frame: .zero)
            setupView(appModel)
            setupContentView(appModel)
            initView()
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
                contentView
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
            contentLabel.font = .systemFont(ofSize: 14)
        }
        
        private func setupContentView(_ appModel: AppModel) {
            showMoreAction = UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let self = self else { return }
                    self.showMoreButton.isHidden = true
                    self.contentLabel.text = appModel.description
                }
            })
            let descriptionArray = appModel.description.split(separator: "\n")
            contentView.add(contentLabel) {
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            contentView.add(showMoreButton) { [unowned self] in
                var configuration = UIButton.Configuration.plain()
                configuration.title = "더 보기"
                $0.configuration = configuration
                $0.addAction(self.showMoreAction, for: .touchUpInside)
                
                $0.snp.makeConstraints { make in
                    make.trailing.bottom.equalToSuperview()
                }
            }
            if descriptionArray.count > 3 {
                contentLabel.text = descriptionArray[0] + "\n" + descriptionArray[1] + "\n" + descriptionArray[2]
                showMoreButton.isHidden = false
            } else {
                contentLabel.text = appModel.description
                showMoreButton.isHidden = true
            }
        }
    }
}

