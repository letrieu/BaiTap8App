//
//  PostCell.swift
//  BaiTap8App
//
//  Created by Trieu Le on 11/11/16.
//  Copyright © 2016 Trieu Le. All rights reserved.
//

import UIKit

protocol PostCellDelegate{
    func btnCommentAction(_ id: Int)
}

class PostCell: UITableViewCell {
    var cardView: UIView?
    var lbTitle: UILabel?
    var lbText: UILabel?
    var btnComment: UIButton?
    var cellData: [String: AnyObject]?
    var delegate: PostCellDelegate?
    
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
        
        lbTitle = UILabel()
        lbTitle?.translatesAutoresizingMaskIntoConstraints = false
        lbTitle?.font = lbTitle?.font.withSize(16)
        lbTitle?.textColor = .black
        lbTitle?.backgroundColor = .clear
        lbTitle?.numberOfLines = 1
        cardView?.addSubview(lbTitle!)
        
        lbText = UILabel()
        lbText?.translatesAutoresizingMaskIntoConstraints = false
        lbText?.font = lbText?.font.withSize(12)
        lbText?.textColor = .black
        lbText?.backgroundColor = .clear
        lbText?.numberOfLines = 2
        cardView?.addSubview(lbText!)
        
        btnComment = UIButton()
        btnComment?.translatesAutoresizingMaskIntoConstraints = false
        btnComment?.setImage(UIImage(named: "chat"), for: .normal)
        btnComment?.addTarget(self, action: #selector(btnCommentTapped(_:)), for: .touchUpInside)
        btnComment?.setTitle("Comment", for: .normal)
        btnComment?.titleLabel?.textColor = .white
        btnComment?.backgroundColor = UIColor(rgb: 0x00B0FF)
        cardView?.addSubview(btnComment!)
        
        let viewsDict = [
            "cardView": cardView!,
            "lbTitle": lbTitle!,
            "lbText": lbText!,
            "btnComment": btnComment!,
            ] as [String : Any]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[cardView]-4-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[cardView]-4-|", options: [], metrics: nil, views: viewsDict))
        cardView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[lbTitle]-4-|", options: [], metrics: nil, views: viewsDict))
        cardView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[lbText]-4-|", options: [], metrics: nil, views: viewsDict))
        cardView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnComment]|", options: [], metrics: nil, views: viewsDict))
        cardView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[lbTitle]-4-[lbText]-[btnComment(30)]|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData( _ data: [String: AnyObject]){
        lbTitle?.text = data["title"] as! String?
        lbText?.text = data["body"] as! String?
        cellData = data
    }
    
    func btnCommentTapped(_ sender: AnyObject){
        delegate?.btnCommentAction(cellData?["id"] as! Int)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
