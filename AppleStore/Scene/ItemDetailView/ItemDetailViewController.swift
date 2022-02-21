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
    
    private var previewTitleLabel = UILabel()
    private var previewScrollView = UIScrollView()
    private var previewStackView = UIStackView()
    private var rateLabel = UILabel()
    private var rateView = CosmosView()
    private var reviewButton: UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "리뷰 작성"
        configuration.image = UIImage(systemName: "square.and.pencil")
        let button = UIButton()
        button.configuration = configuration
        return button
    }
    
    private var supportButton: UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "앱 지원"
        configuration.image = UIImage(systemName: "questionmark.circle")
        let button = UIButton()
        button.configuration = configuration
        return button
    }
    
    private var informationTitleLabel = UILabel()
    
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
        setupPreview()
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
                    VStackView([
                        attributeScrollView,
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
                HStackView([
                    HSpaceView(20),
                    previewTitleLabel,
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                previewScrollView,
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    UIView().separatorView(),
                    HSpaceView(20),
                ]),
                HStackView([
                    HSpaceView(20),
                    ItemDetailViewController.DescriptionView(appModel),
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    UIView().separatorView(),
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    ItemDetailViewController.RateAndReviewView(appModel),
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    UIView().separatorView(),
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    rateLabel,
                    UIView(),
                    rateView,
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(16),
                    reviewButton,
                    UIView(),
                    supportButton,
                    HSpaceView(16),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    UIView().separatorView(),
                    HSpaceView(20),
                ]),
                VSpaceView(20),
                HStackView([
                    HSpaceView(20),
                    VStackView([
                        informationTitleLabel,
                        VSpaceView(20),
                        ItemDetailViewController.InformationItemView(left: "제공자", right: appModel.sellerName),
                        UIView().separatorView(),
                        ItemDetailViewController.InformationItemView(left: "크기", right: "\(String(format: "%.2f", appModel.megaBytes))MB"),
                        UIView().separatorView(),
                        ItemDetailViewController.InformationItemView(left: "카테고리", right: appModel.genre),
                        UIView().separatorView(),
                        ItemDetailViewController.InformationItemView(left: "호환성", right: "이 iPhone과 호환"),
                        UIView().separatorView(),
                        ItemDetailViewController.InformationItemView(left: "언어", right: appModel.supportedLanguages[0]),
                        UIView().separatorView(),
                        ItemDetailViewController.InformationItemView(left: "연령 등급", right: appModel.contentAdvisoryRating),
                        UIView().separatorView(),
                        ItemDetailViewController.InformationItemView(left: "저작권", right: appModel.sellerName),
                    ]),
                    HSpaceView(20),
                ]),
                UIView(),
            ])
        )
    }
    
    private func setupViews() {
        let titleView = UIImageView()
        titleView.setImage(appModel.icon)
        self.navigationItem.titleView = titleView
        titleLabel.text = appModel.name
        titleLabel.font = .preferredFont(forTextStyle: .title1)
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
        
        previewTitleLabel.text = "미리보기"
        previewTitleLabel.font = .boldSystemFont(ofSize: 24)
        
        rateLabel.text = "탭하여 평가하기"
        rateLabel.textColor = .lightGray
        rateLabel.font = .systemFont(ofSize: 18)
        rateView.settings.emptyBorderColor = .systemBlue
        rateView.settings.filledColor = .systemBlue
        rateView.settings.filledBorderColor = .systemBlue
        rateView.settings.fillMode = .half
        rateView.rating = 0
        
        informationTitleLabel.text = "정보"
        informationTitleLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    private func setupAttributeViews() {
        attributeScrollView.add(attributeStackView) { [unowned self] in
            $0.addArranged([
                VStackView([
                    HStackView([
                        HSpaceView(20),
                        VStackView([
                            UIView().separatorView(),
                            HStackView([
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
                                ItemDetailViewController.DetailView(.genre, self.appModel, 100),
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
                            ]),
                            UIView().separatorView(),
                        ]),
                        HSpaceView(20),
                    ]),
                ])
                
            ])
            $0.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }
    
    private func setupPreview() {
        previewScrollView.add(previewStackView) {
            $0.addArranged(HSpaceView(20))
            $0.addArranged(HSpaceView(20))
            $0.axis = .horizontal
            $0.spacing = 8
            $0.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
        for (i, v) in appModel.screenshots.enumerated() {
            let imageView = UIImageView()
            
            let height = self.view.frame.height * 0.5
            previewStackView.insertArranged(imageView, at: i + 1) {
                $0.layer.masksToBounds = true
                $0.layer.cornerRadius = 24
                $0.setImage(v) { image in
                    let _width = height * image.preferredPresentationSizeForItemProvider.width / image.preferredPresentationSizeForItemProvider.height
                    imageView.snp.makeConstraints { make in
                        make.height.equalTo(height)
                        make.width.equalTo(_width)
                    }
                }
                $0.contentMode = .scaleAspectFit
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
    
    private func imageRatio(size: CGSize?) -> CGFloat {
        guard let size = size else { return 320 }
        return CGFloat(size.width / size.height)
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
