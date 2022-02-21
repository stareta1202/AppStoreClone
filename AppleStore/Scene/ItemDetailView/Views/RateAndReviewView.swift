//
//  RateAndReviewView.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/21.
//

import Foundation
import UIKit

extension ItemDetailViewController {
    class RateAndReviewView: UIView {
        private var titleLabel: UILabel {
            let label = UILabel()
            label.text = "평가 및 리뷰"
            label.font = .boldSystemFont(ofSize: 24)
            return label
        }
        
        private var showButton: UIButton {
            var configuration = UIButton.Configuration.plain()
            configuration.title = "모두 보기"
            let button = UIButton()
            button.configuration = configuration
            return button
        }
        
        private var rateLabel = UILabel()
        private var bestRateLabel: UILabel {
            let label = UILabel()
            label.text = "(최고 5점)"
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 16)
            label.textColor = .lightGray
            return label
        }
        
        private let rateCountLabel = UILabel()
        
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
                    showButton,
                ]),
                VSpaceView(16),
                HStackView([
                    VStackView([
                        rateLabel,
                        bestRateLabel
                    ]),
                    UIView(),
                    VStackView([
                        UIView(),
                        rateCountLabel
                    ]),
                ])
            ])) {
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        
        private func setupView(_ appModel: AppModel) {
            rateLabel.text = String(format: "%.1f", appModel.averageUserRating)
            rateLabel.font = .boldSystemFont(ofSize: 64)
            rateLabel.textAlignment = .center
            rateCountLabel.text = "\(appModel.userRatingCount)개의 평가"
            rateCountLabel.textColor = .lightGray
        }
    }
}

