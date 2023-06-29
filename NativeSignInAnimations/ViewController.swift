//
//  ViewController.swift
//  NativeSignInAnimations
//
//  Created by Keith Staines on 27/06/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField: AnimatedPlaceholderTextField!
    @IBOutlet var animatedServiceView: AnimatedServiceView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func didTapAnimate(_ sender: Any) {
        textField.resignFirstResponder()
        textField.underlineState = .error
        textField.animatePlaceholder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.placeholder = "Test Placeholder"
        textField.delegate = self
        textField.underlineState = .plain
        animatedServiceView.loadServiceImages()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let textFieldWindowRect = scrollView.convert(textField.frame, to: .none)
            if endFrameY >= textFieldWindowRect.maxY {
                scrollView.contentOffset.y = 0
            } else {
                scrollView.contentOffset.y -= (endFrameY - textFieldWindowRect.maxY - (textFieldWindowRect.height + 30))
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let animatedField = textField as? AnimatedPlaceholderTextField
        else { return }
        animatedField.underlineState = .focused
        animatedField.animatePlaceholder()
    }
}
