//
//  AnimatedServiceView.swift
//  NativeSignInAnimations
//
//  Created by Sohel Dhengre on 28/06/2023.
//

import UIKit

class AnimatedServiceView: UIStackView {
    
    enum Service: Int, CaseIterable {
        case iPlayer
        case sounds
        case news
        case sport
        case weather
        case bitesize
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        loadServiceImages()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setServiceImagesStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setServiceImagesStackView()
    }
    
    func loadServiceImages() {
        for service in Service.allCases {
            guard let service = Service(rawValue: service.rawValue),
                  let gifData = getServiceImageDataAsset(for: service)?.data,
                  let serviceImageView = arrangedSubviews[service.rawValue] as? UIImageView
            else { continue }
            let animationImages = UIImage.imagesFromGIFData(gifData)
            serviceImageView.animationImages = animationImages
            serviceImageView.animationRepeatCount = 1
            serviceImageView.startAnimating()
            serviceImageView.image = animationImages.last
        }
    }
}

extension AnimatedServiceView {
    
    fileprivate func setServiceImagesStackView() {
        axis = .horizontal
        distribution = .fillEqually
        Service.allCases.forEach { service in
            let imageView = UIImageView()
            addArrangedSubview(imageView)
        }
    }
    
    fileprivate func getServiceImageDataAsset(for service: Service) -> NSDataAsset? {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return NSDataAsset(name: "service\(service.rawValue)-dark")
        default:
            return NSDataAsset(name: "service\(service.rawValue)-light")
        }
    }
}
