//
//  Spinner.swift
//  Blacktop
//
//  Created by Daniel Stahl on 9/5/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit

class Spinner: UIView {
    
    var spinner: UIActivityIndicatorView?
    
    func startSpinner(view: UIView) {
        let screenSize = UIScreen.main.bounds
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: screenSize.height / 2)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2511912882, green: 0.2511980534, blue: 0.2511944175, alpha: 1)
        spinner?.startAnimating()
        view.addSubview(spinner!)
    }
    
    func stopSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
}
