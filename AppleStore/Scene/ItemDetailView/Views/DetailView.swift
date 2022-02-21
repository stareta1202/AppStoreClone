//
//  Views.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/21.
//

import Foundation
import Cosmos
import UIKit

extension ItemDetailViewController {
    class DetailView: UIView {
        private var topLabel = UILabel()
        private var centerView = UIView()
        private var bottomView = UIView()
        
        init(_ type: DetailType, _ appModel: AppModel, _ size: CGFloat) {
            super.init(frame: .zero)
            initView(type, size)
            setupView(type, appModel)
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initView(_ type: DetailType, _ size: CGFloat) {
            self.snp.makeConstraints { make in
                make.height.equalTo(size)
                make.width.greaterThanOrEqualTo(size)
            }
            self.add(
                VStackView([
                    VSpaceView(12),
                    topLabel,
                    UIView(),
                    centerView,
                    UIView(),
                    bottomView,
                    VSpaceView(12),
                ])
            ) {
                $0.distribution = .fill
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        
        private func setupView(_ type: DetailType, _ appModel: AppModel) {
            topLabel.font = .preferredFont(forTextStyle: .caption1)
            topLabel.textColor = .lightGray
            topLabel.textAlignment = .center
            switch type {
            case .rating:
                topLabel.text = "수많은 평가"
                centerView.add(UILabel()) {
                    $0.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                    }
                    $0.text = String(format: "%.1f", appModel.averageUserRating)
                    $0.font = .boldSystemFont(ofSize: 24)
                    $0.textColor = .lightGray
                    $0.textAlignment = .center
                }
                
                bottomView.add(CosmosView()) {
                    $0.settings.fillMode = .precise
                    $0.settings.updateOnTouch = false
                    $0.settings.starSize = 12
                    $0.rating = appModel.averageUserRating
                    $0.settings.filledColor = .lightGray
                    $0.settings.filledBorderColor = .lightGray
                    $0.settings.emptyBorderColor = .lightGray
                    $0.snp.makeConstraints { make in
                        make.top.bottom.equalToSuperview()
                        make.centerX.equalToSuperview()
                    }
                }
            case .age:
                topLabel.text = "연령"
                centerView.add(UILabel()) {
                    $0.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                    }
                    $0.text = appModel.contentAdvisoryRating
                    $0.textColor = .lightGray
                    $0.textAlignment = .center
                    $0.font = .boldSystemFont(ofSize: 24)
                }
                bottomView.add(UILabel()) {
                    $0.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    $0.text = "세"
                    $0.textColor = .lightGray
                    $0.textAlignment = .center
                    $0.font = .preferredFont(forTextStyle: .caption2)
                }
                
            case .genre:
                topLabel.text = "차트"
                centerView.add(UILabel()) {
                    $0.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                    }
                    $0.text = "#7"
                    $0.textColor = .lightGray
                    $0.textAlignment = .center
                    $0.font = .boldSystemFont(ofSize: 24)
                }
                bottomView.add(UILabel()) {
                    $0.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    $0.text = appModel.genre
                    $0.textColor = .lightGray
                    $0.font = .preferredFont(forTextStyle: .caption2)
                    $0.textAlignment = .center
                    
                }
            case .developer:
                topLabel.text = "개발자"
                centerView.add(UIImageView()) {
                    $0.image = UIImage(systemName: "person.crop.square")?.withTintColor(.lightGray)
                    $0.tintColor = .lightGray
                    $0.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.height.equalTo(24)
                    }
                }
                bottomView.add(UILabel()) {
                    $0.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    $0.text = appModel.sellerName
                    $0.textColor = .lightGray
                    $0.font = .preferredFont(forTextStyle: .caption2)
                    $0.textAlignment = .center
                }
                
            case .language:
                topLabel.text = "언어"
                centerView.add(UILabel()) {
                    $0.textAlignment = .center
                    $0.text = appModel.supportedLanguages[0]
                    $0.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                    }
                    $0.textColor = .lightGray
                    $0.font = .boldSystemFont(ofSize: 24)
                }
                bottomView.add(UILabel()) {
                    $0.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    $0.textAlignment = .center
                    $0.text = appModel.supportedLanguages.count > 1 ? "+ \(appModel.supportedLanguages.count)개 언어" : "언어"
                    $0.font = .preferredFont(forTextStyle: .caption2)
                    $0.textColor = .lightGray
                }
            }
        }
        static func separatorView() -> UIView {
            let view = UIView()
            view.backgroundColor = .lightGray
            view.snp.makeConstraints { make in
                make.width.equalTo(0.3)
            }
            return view
        }
    }
}
