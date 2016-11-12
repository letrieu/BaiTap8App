//
//  ViewController.swift
//  BaiTap8App
//
//  Created by Trieu Le on 11/11/16.
//  Copyright © 2016 Trieu Le. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    var tableView: UITableView?
    var arrPost = [[String:AnyObject]]()
    var refreshControl: UIRefreshControl?
    var activityIndicator: UIActivityIndicatorView?
    
    var popUpView: PopUpView?
    var blurEffectView: UIVisualEffectView?
    
    override func loadView() {
        super.loadView()
        tableView = UITableView()
        tableView?.backgroundColor = .white
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView?.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator!)
        
        view.addConstraint(NSLayoutConstraint(item: activityIndicator!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: activityIndicator!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView?.isHidden = true
        view.addSubview(blurEffectView!)
        
        popUpView = PopUpView()
        popUpView?.awakeFromNib()
        popUpView?.translatesAutoresizingMaskIntoConstraints = false
        popUpView?.layer.cornerRadius = 5
        popUpView?.clipsToBounds = true
        popUpView?.backgroundColor = .green
        popUpView?.isHidden = true
        view.addSubview(popUpView!)
        
        
        let viewsDict = [
            "tableView": tableView!,
            "blurEffectView": blurEffectView!,
            "popUpView": popUpView!
            ] as [String : Any]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[blurEffectView]|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[blurEffectView]|", options: [], metrics: nil, views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[popUpView]-24-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[popUpView]-24-|", options: [], metrics: nil, views: viewsDict))
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator?.startAnimating()
        APIManager.shared.getPostList(self)
    }
    
    func refresh(_ sender: AnyObject) {
        APIManager.shared.getPostList(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeBlur()
        animateOut()
    }
    
    public func showBlur() {
        blurEffectView?.isHidden = false
    }
    
    public func removeBlur() {
        blurEffectView?.isHidden = true
    }
    
    
    func animateIn() {
        popUpView?.isHidden = false
        popUpView?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView?.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            
            self.popUpView?.alpha = 1
            self.popUpView?.transform = CGAffineTransform.identity
        }
        
    }
    
    public func animateOut () {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.popUpView?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popUpView?.alpha = 0
            
        }) { (success:Bool) in
            
            DispatchQueue.global(qos: .background).async { [unowned self] in
                self.popUpView?.arrComment.removeAll()
                DispatchQueue.main.async { [unowned self] in
                    
                    self.popUpView?.tableView?.reloadData()
                }
                
            }
            
            self.popUpView?.isHidden = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first != nil{
            
            removeBlur()
            animateOut()
            
        }
        super.touchesBegan(touches , with:event)
        
    }
}

extension ViewController: APIManagerDelegate {
    func processResultResponseData(_ result: Any, requestId: Int){
        if (requestId == requestApiId.request_posts.rawValue)
        {
            
            
            DispatchQueue.global(qos: .background).async { [unowned self] in
                let swiftyJsonVar = JSON(result)
                if let arr = swiftyJsonVar.arrayObject {
                    self.arrPost = arr as! [[String : AnyObject]]
                }
                DispatchQueue.main.async { [unowned self] in
                    self.refreshControl?.endRefreshing()
                    self.activityIndicator?.stopAnimating()
                    self.tableView?.reloadData()
                }
                
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? PostCell
        {
            let dict = arrPost[indexPath.row]
            cell.setData(dict)
            cell.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension ViewController: PostCellDelegate {
    func btnCommentAction(_ id: Int){
        showBlur()
        animateIn()
        popUpView?.post_id = id
    }
}

