//
//  StartPageCell.swift
//  TorontoBiker
//
//  Created by Jen-Hao Hsiao on 2017-11-19.
//  Copyright © 2017 HSIAO JENHAO. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StartPageCell: UITableViewCell , MKMapViewDelegate{
    
    var satationName: UILabel!
    
    var bikesAvailable : UILabel!
    var docksAvailable : UILabel!
    var distancelable: UILabel!
    var labelBikes : UILabel!
    var labelDocks : UILabel!
    var labelDistance : UILabel!
    
    var mapForReview  : MKMapView!
    let fullScreenSize = UIScreen.main.bounds.size
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.satationName  = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: fullScreenSize.width - 20, height: 46))
        
        self.satationName .textColor = UIColor.black
        self.satationName .font = UIFont.systemFont(ofSize: 20)
        self.satationName .text = "satationName"
        self.satationName.numberOfLines = 0
        contentView.addSubview(self.satationName )
        
        
        
        labelBikes = UILabel(frame: CGRect.init(x: 20 , y: 40, width: fullScreenSize.width - 40, height: 35))
        labelBikes.textColor = UIColor.black
        labelBikes .font = UIFont.systemFont(ofSize: 15.0)
        labelBikes.text = "Bikes: "
        contentView.addSubview(labelBikes )
        
        
        labelDocks = UILabel(frame: CGRect.init(x: 20 , y: 70, width: fullScreenSize.width - 40, height: 35))
        labelDocks.textColor = UIColor.black
        labelDocks .font = UIFont.systemFont(ofSize: 15.0)
        labelDocks.text = "Docks: "
        contentView.addSubview(labelDocks )
        
        labelDistance = UILabel(frame: CGRect.init(x: 20, y: 100, width: fullScreenSize.width - 40, height: 35))
        labelDistance.textColor = UIColor.black
        labelDistance .font = UIFont.systemFont(ofSize: 15.0)
        labelDistance.text = "Dist: "
        contentView.addSubview(labelDistance )
        
        
        self.bikesAvailable  = UILabel.init(frame: CGRect.init(x: 70 , y: 40, width: fullScreenSize.width - 40, height: 35))
        self.bikesAvailable .textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        self.bikesAvailable .font = UIFont.systemFont(ofSize: 20)
        self.bikesAvailable .text = "bikesAvailabl"
        contentView.addSubview(self.bikesAvailable )
        
        
        self.docksAvailable  = UILabel.init(frame: CGRect.init(x: 70, y: 70, width: fullScreenSize.width - 40, height: 35))
        self.docksAvailable .textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        self.docksAvailable .font = UIFont.systemFont(ofSize: 20)
        self.docksAvailable .text = "docksAvailable"
        contentView.addSubview(self.docksAvailable )
        
        
        self.distancelable  = UILabel.init(frame: CGRect.init(x: 70, y: 100, width: fullScreenSize.width - 40, height: 35))
        self.distancelable .textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        self.distancelable .font = UIFont.systemFont(ofSize: 20)
        self.distancelable .text = "N km"
        contentView.addSubview(self.distancelable )
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        
        
        self.mapForReview = MKMapView(frame: CGRect(x: fullScreenSize.width * 0.5, y: 40,
            width: (fullScreenSize.width * 0.5) - 20,
            height: 100))
        self.mapForReview.layer.cornerRadius = 10
        contentView.addSubview(self.mapForReview )
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
