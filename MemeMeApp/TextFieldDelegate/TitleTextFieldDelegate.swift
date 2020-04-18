//
//  TitleTextFieldDelegate.swift
//  MemeMeApp
//
//  Created by Gustavo Brunetto on 2020-04-17.
//  Copyright © 2020 Gustavo Brunetto. All rights reserved.
//

import Foundation
import UIKit

class TitleTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
