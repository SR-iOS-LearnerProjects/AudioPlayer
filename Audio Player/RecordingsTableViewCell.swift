//
//  RecordingsTableViewCell.swift
//  Audio Player
//
//  Created by Sridatta Nallamilli on 13/02/20.
//  Copyright © 2020 MAC006. All rights reserved.
//

import UIKit

class RecordingsTableViewCell: UITableViewCell {

    @IBOutlet weak var recNameLbl: UILabel!
    @IBOutlet weak var playRecImg: UIImageView!
    @IBOutlet weak var playRecBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    

}
