//
//  AnimatedPlaceholderTextField.swift
//  NativeSignInAnimations
//
//  Created by Keith Staines on 27/06/2023.
//

import UIKit

final class AnimatedPlaceholderTextField: UITextField {
    
    var scaleFraction = CGFloat(0.85)
    let duration: TimeInterval = 0.3
    private var placeholderText: String?
    private var yOffset: CGFloat = 0
    let xOffset: CGFloat = 0
    private var unscaledPlaceholderFontSize: CGFloat = 20
    let translationFix = CGFloat(-5) //Found by trial and error
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: unscaledPlaceholderFontSize)
        return label
    }()
    
    lazy var underlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var underlineState: UnderlineStates {
        didSet {
            underlineView.backgroundColor = underlineState.color
            underlineViewHeightConstraint.constant = underlineState.height
        }
    }
    
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
    
    lazy var underlineViewYConstraint: NSLayoutConstraint = {
        underlineView
            .topAnchor
            .constraint(
                equalTo: self.bottomAnchor,
                constant: 5
            )
    }()
    
    lazy var underlineViewLeadingConstraint: NSLayoutConstraint = {
        underlineView
            .leadingAnchor
            .constraint(
                equalTo: self.leadingAnchor,
                constant: 0
            )
    }()
    
    lazy var underlineViewTrailingConstraint: NSLayoutConstraint = {
        underlineView
            .trailingAnchor
            .constraint(
                equalTo: self.trailingAnchor,
                constant: 0
            )
    }()
    
    lazy var underlineViewHeightConstraint: NSLayoutConstraint = {
        underlineView
            .heightAnchor.constraint(equalToConstant: 1)
    }()
    
    override var font: UIFont? {
        set {
            super.font = newValue
            placeholderLabel.font = newValue
            placeholderLabel.textColor = .gray
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
        CGAffineTransform(translationX: translationFix, y: translationFix).scaledBy(x: scaleFraction, y: scaleFraction)
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
        
        UIView.animate(
            withDuration: duration) { [weak self] in
                guard let self = self else { return }
                self.placeholderLabel.transform = self.scaleTransform
                layoutIfNeeded()
            } completion: { didFinish in
                completion?(didFinish)
            }
    }
    
    fileprivate func initialSetup() {
        placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        addSubview(placeholderLabel)
        addSubview(underlineView)
        
        NSLayoutConstraint.activate(
            [placeholderCenterYConstraint,
             placeholderLeadingConstraint,
             underlineViewYConstraint,
             underlineViewLeadingConstraint,
             underlineViewTrailingConstraint,
             underlineViewHeightConstraint
            ]
        )
    }
    
    init(placeholderText: String? = nil) {
        self.placeholderText = placeholderText
        underlineState = .plain
        super.init(frame: CGRect.zero)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        self.placeholderText = ""
        underlineState = .plain
        super.init(frame: CGRect.zero)
        initialSetup()
    }
}

extension AnimatedPlaceholderTextField {
    
    enum UnderlineStates {
        case error
        case focused
        case plain
        
        var height: CGFloat {
            switch self {
            case .error, .focused:
                return 3
            case .plain:
                return 1.2
            }
        }
        
        var color: UIColor {
            switch self {
            case .error:
                return .red
            case .focused, .plain:
                return .black
            }
        }
    }
}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
