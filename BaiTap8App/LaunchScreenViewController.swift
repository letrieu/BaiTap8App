//
//  LaunchScreenViewController.swift
//  BaiTap8App
//
//  Created by Trieu Le on 11/12/16.
//  Copyright © 2016 Trieu Le. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor(rgb: 0x1E88E5)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator!)
        
        view.addConstraint(NSLayoutConstraint(item: activityIndicator!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: activityIndicator!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator?.startAnimating()
        
        self.perform(#selector(LaunchScreenViewController.afterLoad), with: nil, afterDelay: 2)
    }
    
    func afterLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        self.present(controller, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
