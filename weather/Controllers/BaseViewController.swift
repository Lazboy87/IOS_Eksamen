//
//  BaseViewController.swift
//  weather
//
//  Created by Lasse Hovden on 24/11/2020.
//

import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        hideKeyboardOnTap()
    }
    
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAfterTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboardAfterTap() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) as? UITextField {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func showActivityIndicator() {
        ActivityIndicator.start()
    }
    
    func hideActivityIndicator() {
        ActivityIndicator.stop()
    }
    
    func showAlert(title: String = "", message: String, feedback: Feedback? = nil, completion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            completion?()
        }))
        
        self.present(alertController, animated: true, completion: nil)
        feedback?.generate()
    }
    
    func isConnectedToInternet() -> Bool {
        do {
            let reachability = try Reachability()
            
            if reachability.connection == .unavailable {
                showNoNetworkAlert()
                return false
            } else {
                return true
            }
            
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func showNoNetworkAlert()
    {
        let alertController = UIAlertController (title: "Cellular Data is Turned Off", message: "Turn on cellular data or use Wi-Fi to access data.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
