//
//  ViewController.swift
//  Tut_TelefonNumarasiFormatlamak
//
//  Created by ruroot on 9/29/18.
//  Copyright © 2018 Eray Alparslan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = format(phoneNumber: fullString)
            }
        }
        else {
            return true
        }
        return false
    }
    

    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        
        guard !phoneNumber.isEmpty else { return "" }
        
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        
        if number.count > 11 {
            
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 11)
            
            number = String(number[number.startIndex..<tenthDigitIndex])
            
        }
        
        
        
        if shouldRemoveLastDigit {
            
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            
            number = String(number[number.startIndex..<end])
            
        }
        
        
        
        if number.count < 8 {
            
            let end = number.index(number.startIndex, offsetBy: number.count)
            
            let range = number.startIndex..<end
            
            number = number.replacingOccurrences(of: "(\\d{4})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
            
            
        } else {
            
            let end = number.index(number.startIndex, offsetBy: number.count)
            
            let range = number.startIndex..<end
            
            number = number.replacingOccurrences(of: "(\\d{4})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
            
        }
        
        
        
        return number
        
    }
}

