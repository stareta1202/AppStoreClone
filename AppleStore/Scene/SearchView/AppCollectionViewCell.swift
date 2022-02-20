//
//  AppCollectionViewCell.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/20.
//

import Foundation
import UIKit

class AppCollectionViewCell: UICollectionViewCell {
    static let identifier = "AppCollectionViewCell"
    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var getButton = UIButton()
    private var screenshotImageStackView = UIStackView()
    private var screenshotImageViews: [UIImageView] = []
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    
    
    private func initView() {
        contentView.add(iconImageView) {
            $0.backgroundColor = .blue
            $0.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(20)
                make.width.height.equalTo(60)
            }
        }
        
        contentView.add(UIStackView()) { [unowned self] in
            $0.axis = .vertical
            $0.addArranged(self.titleLabel)
            $0.addArranged(self.descriptionLabel) {
                $0.font = .preferredFont(forTextStyle: .footnote)
                $0.textColor = .lightGray
            }
            $0.snp.makeConstraints { make in
                make.leading.equalTo(self.iconImageView.snp.trailing).offset(16)
                make.trailing.equalToSuperview().inset(96)
                make.top.equalTo(self.iconImageView.snp.top)
            }
        }
        
        contentView.add(getButton) { [unowned self] in
            var configuration = UIButton.Configuration.tinted()
            
            configuration.cornerStyle = .capsule
            var container = AttributeContainer()
            container.font = UIFont.boldSystemFont(ofSize: 14)
            configuration.attributedTitle = AttributedString("받기", attributes: container)
            $0.configuration = configuration
            $0.snp.makeConstraints { make in
                make.width.equalTo(60)
                make.trailing.equalToSuperview().inset(20)
                make.centerY.equalTo(self.iconImageView)
            }
        }
    }
    
    func configure(_ appModel: AppModel) {
        self.titleLabel.text = appModel.name
        self.descriptionLabel.text = appModel.genre
        self.iconImageView.setImage(appModel.icon)
    }
}