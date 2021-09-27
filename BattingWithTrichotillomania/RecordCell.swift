//
//  CheckrecordCell.swift
//  BattingWithTrichotillomania
//
//  Created by Lucy Han on 09/14/2021.
//


import UIKit

class RecordCell: UITableViewCell {
    
    let ratingcontrol: RatingControl = {
        let rating = RatingControl()
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    
    let recordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        // imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = BWTFormatConstants.timestampFormatStr
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    
    var checkrecord: Record?
    {
        didSet {
           
            if let photoUrl =  checkrecord?.recordImageUrl {
                self.recordImageView.loadImageUsingCacheWithUrlString(photoUrl)
            }
            
            if let rating = checkrecord?.rating {
                self.ratingcontrol.rating = rating
            }
            
            if let seconds = checkrecord?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = BWTFormatConstants.timestampFormatStr
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(recordImageView)
        addSubview(ratingcontrol)
        addSubview(timeLabel)
        
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
       
        recordImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        recordImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        recordImageView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        recordImageView.heightAnchor.constraint(equalToConstant: 42).isActive = true
                
                        	
        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-2).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //timeLabel.backgroundColor = UIColor.black
        timeLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        
        ratingcontrol.leftAnchor.constraint(equalTo: recordImageView.rightAnchor, constant: 18).isActive = true
        ratingcontrol.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -28).isActive = true
        ratingcontrol.widthAnchor.constraint(equalToConstant: 200).isActive = true
        ratingcontrol.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        // ratingcontrol.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //ratingcontrol.backgroundColor = UIColor.black
        ratingcontrol.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
}


