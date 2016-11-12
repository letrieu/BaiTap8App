//
//  PopUpView.swift
//  BaiTap8App
//
//  Created by Trieu Le on 11/11/16.
//  Copyright © 2016 Trieu Le. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PopUpView: UIView {
    
    var tableView: UITableView?
    var refreshControl: UIRefreshControl?
    var activityIndicator: UIActivityIndicatorView?
    var post_id: Int? {
        didSet {
            activityIndicator?.startAnimating()
            APIManager.shared.getComments(self, post_id: post_id!)
        }
    }
    var arrComment = [[String:AnyObject]]()
    
    override func awakeFromNib() { //same as didload for UIView
        
        tableView = UITableView()
        tableView?.backgroundColor = .white
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView?.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.dataSource = self
        tableView?.delegate = self
        self.addSubview(tableView!)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator!)
        
        self.addConstraint(NSLayoutConstraint(item: activityIndicator!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: activityIndicator!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        let viewsDict = [
            "tableView": tableView!,
            ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: viewsDict))
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl!)
    }
    
    func refresh(_ sender: AnyObject) {
        APIManager.shared.getComments(self, post_id: post_id!)
    }
    
}

extension PopUpView: APIManagerDelegate {
    func processResultResponseData(_ result: Any, requestId: Int) {
        if (requestId == requestApiId.request_comments.rawValue)
        {
            DispatchQueue.global(qos: .background).async { [unowned self] in
                let swiftyJsonVar = JSON(result)
                if let arr = swiftyJsonVar.arrayObject {
                    self.arrComment = arr as! [[String : AnyObject]]
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

extension PopUpView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(arrComment.count) comments"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath as IndexPath) as! CommentCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CommentCell
        {
            let dict = arrComment[indexPath.row]
            cell.setData(dict)
        }
    }
}
