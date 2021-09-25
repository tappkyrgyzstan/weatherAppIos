//
//  File.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 21/9/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func controller<T:UIViewController> (name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}




