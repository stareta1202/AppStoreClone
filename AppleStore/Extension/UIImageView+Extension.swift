//
//  UIImageView+Extension.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/20.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(_ url: String?, _ closure:  ((UIImage) -> Void)? = nil) {
        guard let url = url else { return }

        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: url)
            DispatchQueue.main.async {
                if let cachedImage = ImageCacheService.shared.object(forKey: cachedKey) {
                    self.image = cachedImage
                    closure?(cachedImage)
                    return
                }
            }
            
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { (data, result, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage()
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheService.shared.setObject(image, forKey: cachedKey)
                        self?.image = image
                        closure?(image)
                    }
                }
            }.resume()
        }
    }
}

extension UIImageView {
    func withCorner(_ amount: CGFloat) -> UIImageView {
        self.clipsToBounds = true
        self.layer.cornerRadius = amount
        return self
    }
}
