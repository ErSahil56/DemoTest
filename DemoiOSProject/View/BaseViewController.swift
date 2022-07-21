//
//  BaseViewController.swift
//  DemoTest
//
//  Created by Sahil Garg on 21/07/22.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var indicator: UIActivityIndicatorView? = {
        indicator?.style = .large
        indicator?.color = .gray
        return UIActivityIndicatorView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showProgressBar() {
        indicator?.startAnimating()
        if let indicator = indicator {
            self.view.addSubview(indicator)
        }
    }
    
    func hideProgressBar() {
        indicator?.removeFromSuperview()
    }
    
}
