//
//  AllSelectedTripImagesTableViewCell.swift
//  RoamNotes
//
//  Created by Zafran Mac on 06/10/2023.
//

import UIKit

class AllSelectedTripImagesTableViewCell: UITableViewCell {
    @IBOutlet weak var DestinationLabel:UILabel!
    @IBOutlet weak var tripimage:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
