//
//  AnimatedPlaceholderTextField.swift
//  NativeSignInAnimations
//
//  Created by Keith Staines on 27/06/2023.
//

import UIKit

final class AnimatedPlaceholderTextField: UITextField {
    
    let scaleFraction = CGFloat(0.7)
    let duration: TimeInterval = 0.3
    private var placeholderText: String?
    private var yOffset: CGFloat = 0
    let xOffset: CGFloat = 30
    private var unscaledPlaceholderFontSize: CGFloat = 20
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: unscaledPlaceholderFontSize)
        return label
    }()
    
    lazy var placeholderCenterYConstraint: NSLayoutConstraint = {
        placeholderLabel
            .centerYAnchor
            .constraint(
                equalTo: centerYAnchor,
                constant: yOffset
            )
    }()
    
    lazy var placeholderLeadingConstraint: NSLayoutConstraint = {
        placeholderLabel
            .leadingAnchor
            .constraint(
                equalTo: leadingAnchor,
                constant: xOffset
            )
    }()
    
    override var font: UIFont? {
        set {
            super.font = newValue
            unscaledPlaceholderFontSize = newValue?.pointSize ?? 20
        }
        
        get {
            super.font
        }
    }
    
    private var scaleTransform: CGAffineTransform {
        isFirstResponder ? scaleTransformWhenIsFirstResponder : .identity
    }
    
    private var scaleTransformWhenIsFirstResponder: CGAffineTransform {
        CGAffineTransform.init(scaleX: scaleFraction, y: scaleFraction)
    }

    
    override var placeholder: String? {
        get {
            placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
        }
    }
    
    /// Animation to move and scale the placeholder text
    /// - Parameter completion: A closure to be executed when the animation sequence ends. This closure has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle. This parameter may be nil
    func animatePlaceholder(completion: ((Bool) -> Void)? = nil ) {
        placeholderCenterYConstraint.constant = isFirstResponder
        ? -self.bounds.height : 0
        
        placeholderLeadingConstraint.constant = isFirstResponder
        ? 0 : xOffset
        
        let scale = isFirstResponder ? scaleFraction : 1
        let scaledSize = scale * unscaledPlaceholderFontSize
        
        UIView.animate(
            withDuration: duration) { [weak self] in
                guard let self = self else { return }
                layoutIfNeeded()
                placeholderLabel.transform = scaleTransform
            } completion: { didFinish in
                completion?(didFinish)
            }
    }
    
    fileprivate func initialSetup() {
        borderStyle = .roundedRect
        addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate(
            [placeholderCenterYConstraint, placeholderLeadingConstraint]
        )
    }
    
    init(placeholderText: String? = nil) {
        self.placeholderText = placeholderText
        super.init(frame: CGRect.zero)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        self.placeholderText = ""
        super.init(frame: CGRect.zero)
        initialSetup()
    }
    
    
    
    
    
}
