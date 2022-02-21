//
//  ReleaseNoteView.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/21.
//

import Foundation
import UIKit

extension ItemDetailViewController {
    class ReleaseNoteView: UIView {
        private let titleLabel = UILabel()
        private let recordButton = UIButton()
        private let versionLabel = UILabel()
        private let dateLabel = UILabel()
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
                HStackView([
                    versionLabel,
                    UIView(),
                    dateLabel,
                ]),
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
            versionLabel.text = "버전 \(appModel.appVersion)"
            versionLabel.textColor = .lightGray
            versionLabel.font = .preferredFont(forTextStyle: .subheadline)
            dateLabel.font = .preferredFont(forTextStyle: .subheadline)
            dateLabel.textColor = .lightGray
            if let dayDiff = Calendar.current.dateComponents([.day], from: appModel.releaseDate!, to: Date()).day,
               dayDiff < 365 {
                dateLabel.text = dayDiff < 7 ? "\(dayDiff)일 전" : "\(dayDiff / 7)주 전"
            } else if let yearDiff = Calendar.current.dateComponents([.year], from: appModel.releaseDate!, to: Date()).year {
                dateLabel.text = "\(yearDiff)년 전"
            }
            contentLabel.numberOfLines = 0
            contentLabel.text = appModel.releaseNotes
            contentLabel.font = .systemFont(ofSize: 14)
        }
    }
}
