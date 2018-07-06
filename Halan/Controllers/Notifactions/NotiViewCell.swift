//
//  NotiViewCell.swift
//  Halan
//
//  Created by hesham tatawy on 22/10/1439 AH.
//  Copyright © 1439 alatheertech. All rights reserved.
//

import UIKit

class NotiViewCell: UITableViewCell {

    @IBOutlet var cost: UILabel!
    
    @IBOutlet var Dateadd: UILabel!
    
    @IBOutlet var Topoint: UITextField!
    
    @IBOutlet var FromPoint: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
