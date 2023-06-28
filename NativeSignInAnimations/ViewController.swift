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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
