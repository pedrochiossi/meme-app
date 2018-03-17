//
//  TextFieldExtension.swift
//  MemeMe App
//
//  Created by Pedro De Morais Chiossi on 14/03/18.
//  Copyright © 2018 Pedro Chiossi. All rights reserved.
//

import UIKit

extension MemeViewController: UITextFieldDelegate {

    
    // clears default text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // restores default text
    func textFieldDidEndEditing(_ textField: UITextField) {
        if topTextField.text!.isEmpty{
            topTextField.text = "TOP"
        } else if bottomTextField.text!.isEmpty {
            bottomTextField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
