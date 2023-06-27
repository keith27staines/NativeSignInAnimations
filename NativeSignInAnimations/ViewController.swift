//
//  ViewController.swift
//  NativeSignInAnimations
//
//  Created by Keith Staines on 27/06/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField: AnimatedPlaceholderTextField!
    @IBOutlet var imageCollection: [UIImageView]!
    
    @IBAction func didTapAnimate(_ sender: Any) {
        textField.resignFirstResponder()
        textField.animatePlaceholder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.placeholder = "Test Placeholder"
        textField.delegate = self
    }
    
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let animatedField = textField as? AnimatedPlaceholderTextField
        else { return }
        animatedField.animatePlaceholder()
    }
}

