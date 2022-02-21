//
//  ItemDetailViewController.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/20.
//

import Foundation
import Combine
import UIKit
import Cosmos
import AddThen

class ItemDetailViewController: UIViewController {
    private var subscription: Set<AnyCancellable> = .init()
    private var appModel: AppModel
    static func instantiate(with appModel: AppModel) -> ItemDetailViewController {
        return ItemDetailViewController(appModel)
    }
    
    private var scrollView = UIScrollView()
    private var builderView = VStackView()
    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var getButton: UIButton {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 16)
        configuration.attributedTitle = AttributedString("받기", attributes: container)
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        return button
    }
    
    private var shareButton: UIButton {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "square.and.arrow.up")
        button.configuration = configuration
        return button
    }
    
    private var attributeScrollView = UIScrollView()
    private var attributeStackView = UIStackView()
    
    private init(_ appModel: AppModel) {
        self.appModel = appModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        updateColor()
        buildView()

    }
    
    private func initView() {
        setupScrollView()
        setupViews()
        setupAttributeViews()
    }
    
    private func buildView() {
        builderView.addArranged(
            VStackView([
                HStackView([
                    HSpaceView(20),
                    iconImageView,
                    HSpaceView(16),
                    VStackView([
                        titleLabel,
                        subTitleLabel,
                        UIView(),
                        HStackView([
                            getButton,
                            UIView(),
                            shareButton,
                        ]),
                    ]),
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                
                HStackView([
                    HSpaceView(20),
                    VStackView([
                        UIView().separatorView(),
                        attributeScrollView,
                        UIView().separatorView(),
                    ]),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    ItemDetailViewController.ReleaseNoteView(appModel),
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    UIView().separatorView(),
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                
                UIView(),
            ])
        )
    }
    
    private func setupViews() {
        titleLabel.text = appModel.name
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textAlignment = .left
        
        // subtitle 안들어오므로 장르로 대체
        subTitleLabel.text = appModel.genre
        subTitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subTitleLabel.textColor = .lightGray
        iconImageView.setImage(appModel.icon)
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 24
        
    }
    
    private func setupAttributeViews() {
        attributeScrollView.add(attributeStackView) { [unowned self] in
            $0.axis = .horizontal
            $0.addArranged([
                ItemDetailViewController.DetailView(.rating, self.appModel, 100),
                VStackView([
                    VSpaceView(20),
                    ItemDetailViewController.DetailView.separatorView(),
                    VSpaceView(20),
                ]),
                ItemDetailViewController.DetailView(.age, self.appModel, 100),
                VStackView([
                    VSpaceView(20),
                    ItemDetailViewController.DetailView.separatorView(),
                    VSpaceView(20),
                ]),
                ItemDetailViewController.DetailView(.developer, self.appModel, 100),
                VStackView([
                    VSpaceView(20),
                    ItemDetailViewController.DetailView.separatorView(),
                    VSpaceView(20),
                ]),
                ItemDetailViewController.DetailView(.language, self.appModel, 100),
                VStackView([
                    VSpaceView(20),
                    ItemDetailViewController.DetailView.separatorView(),
                    VSpaceView(20),
                ]),
                ItemDetailViewController.DetailView(.rating, self.appModel, 100),
            ])
            $0.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
    
    
    
    
    private func setupScrollView() {
        view.add(scrollView) { [unowned self] in
            $0.alwaysBounceVertical = true
            $0.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            }
            $0.add(self.builderView) {
                $0.axis = .vertical
                $0.distribution = .fill
                $0.alignment = .fill
                $0.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.leading.trailing.equalToSuperview()
                    make.width.equalToSuperview()
                }
            }
        }
    }
    private func updateColor() {
        view.backgroundColor = userInterfaceStyle == .light ? .white : .black
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColor()
    }

}

enum DetailType {
    case rating
    case age
    case genre
    case developer
    case language
}

fileprivate extension UIView {
    func separatorView() -> UIView {
        self.backgroundColor = .lightGray
        self.snp.makeConstraints { make in
            make.height.equalTo(0.3)
        }
        return self
    }
}
