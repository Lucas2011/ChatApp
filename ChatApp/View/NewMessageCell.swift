//
//  NewMessageCell.swift
//  Chatdemo
//
//  Created by Lucas on 9/12/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {
    @IBOutlet weak var lbnName: UILabel!
    
    @IBOutlet weak var profileIMG: UIImageView!
    @IBOutlet weak var lbnEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    func setup(){
        profileIMG.contentMode = .scaleAspectFill
        profileIMG.clipsToBounds = true
        profileIMG.layer.cornerRadius = 40
        profileIMG.layer.masksToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
