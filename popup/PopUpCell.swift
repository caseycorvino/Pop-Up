//
//  TableViewCell.swift
//  PopUp
//
//  Created by Code on 10/25/16.
//  Copyright © 2016 PopUp. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var distanceToPerson: UILabel!
    
    @IBOutlet var startTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
