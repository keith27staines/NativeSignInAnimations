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
                  let serviceImage = getServiceImageDataAsset(for: service),
                  let serviceImageView = arrangedSubviews[service.rawValue] as? UIImageView else { continue }
            
            serviceImageView.image = UIImage.gifImageWithData(serviceImage.data)
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
