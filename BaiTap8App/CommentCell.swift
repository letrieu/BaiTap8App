//
//  CommentCell.swift
//  BaiTap8App
//
//  Created by Trieu Le on 11/11/16.
//  Copyright © 2016 Trieu Le. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    var cardView: UIView?
    var lbName: UILabel?
    var lbEmail: UILabel?
    var lbBody: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        cardView = UIView()
        cardView?.translatesAutoresizingMaskIntoConstraints = false
        cardView?.layer.cornerRadius = 5
        cardView?.clipsToBounds = true
        cardView?.layer.borderWidth = 0.5
        cardView?.layer.borderColor = UIColor(rgb: 0x80D8FF).cgColor
        self.addSubview(cardView!)
        
        lbName = UILabel()
        lbName?.translatesAutoresizingMaskIntoConstraints = false
        lbName?.font = lbName?.font.withSize(16)
        lbName?.textColor = .black
        lbName?.backgroundColor = .clear
        lbName?.numberOfLines = 0
        cardView?.addSubview(lbName!)
        
        lbEmail = UILabel()
        lbEmail?.translatesAutoresizingMaskIntoConstraints = false
        lbEmail?.font = lbEmail?.font.withSize(12)
        lbEmail?.textColor = .black
        lbEmail?.backgroundColor = .clear
        lbEmail?.numberOfLines = 0
        cardView?.addSubview(lbEmail!)
        
        lbBody = UILabel()
        lbBody?.translatesAutoresizingMaskIntoConstraints = false
        lbBody?.font = lbBody?.font.withSize(12)
        lbBody?.textColor = .black
        lbBody?.backgroundColor = .clear
        lbBody?.numberOfLines = 0
        cardView?.addSubview(lbBody!)
        
        let viewsDict = [
            "cardView": cardView!,
            "lbName": lbName!,
            "lbEmail": lbEmail!,
            "lbBody": lbBody!,
            ] as [String : Any]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[cardView]-4-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[cardView]-4-|", options: [], metrics: nil, views: viewsDict))
        cardView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[lbName]-4-|", options: [], metrics: nil, views: viewsDict))
        cardView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[lbEmail]-4-|", options: [], metrics: nil, views: viewsDict))
        cardView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[lbBody]-4-|", options: [], metrics: nil, views: viewsDict))
        cardView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[lbName]-4-[lbEmail]-4-[lbBody]|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData( _ data: [String: AnyObject]){
        lbName?.text = "Name: " + (data["name"] as! String)
        lbEmail?.text = "Email: " + (data["email"] as! String)
        lbBody?.text = data["body"] as! String?
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
