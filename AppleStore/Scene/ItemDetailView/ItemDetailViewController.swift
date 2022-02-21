//
//  ItemDetailViewController.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/20.
//

import Foundation
import Combine
import UIKit

class ItemDetailViewController: UIViewController {
    private var subscription: Set<AnyCancellable> = .init()
    private var appModel: AppModel
    static func instantiate(with appModel: AppModel) -> ItemDetailViewController {
        return ItemDetailViewController(appModel)
    }
    
    private var scrollView = UIScrollView()
    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    
    private init(_ appModel: AppModel) {
        self.appModel = appModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    private func initView() {
        
    }
    
    private func setupScrollView() {
        view.add(scrollView) {
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
