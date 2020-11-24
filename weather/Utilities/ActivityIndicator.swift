//
//  ActivityIndicator.swift
//  weather
//
//  Created by Lasse Hovden on 24/11/2020.
//

import Foundation
import UIKit

open class ActivityIndicator {
    
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .whiteLarge
    public static var baseBackColor = UIColor.darkGray.withAlphaComponent(0.5)
    public static var baseColor = UIColor.systemRed
    public static func start(style: UIActivityIndicatorView.Style = style, backColor: UIColor = baseBackColor, baseColor: UIColor = baseColor) {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if spinner == nil, let window = window {
            window.isUserInteractionEnabled = false
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = backColor
            spinner!.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    public static func stop() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if spinner != nil, let window = window {
            window.isUserInteractionEnabled = true
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
    @objc public static func update() {
        if spinner != nil {
            stop()
            start()
        }
    }
}
