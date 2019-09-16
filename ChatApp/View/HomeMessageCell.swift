//
//  HomeMessageCell.swift
//  Chatdemo
//
//  Created by Lucas on 9/14/19.
//  Copyright © 2019 Lucas. All rights reserved.
//

import UIKit

class HomeMessageCell: UITableViewCell {

    @IBOutlet weak var profileIMG: UIImageView!
    @IBOutlet weak var lblmessage: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbltime: UILabel!
    var model:UserModel? {
        didSet{
//            let time = model?.time as NSString?
//            let timeStamp = Date(timeIntervalSinceReferenceDate: time!.doubleValue)
//            let dataFormatter = DateFormatter()
//            dataFormatter.dateFormat = "hh:mm:ss a"
//            self.lbltime.text = dataFormatter.string(from: timeStamp)
            self.lblname.text = model?.name
            self.lblmessage.text = model?.message
            self.profileIMG.loadingImgUsingCatchWithUrlString(url: model!.profileImgUrl!)
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
        
        
        

    }
    
    func setup(){
        
        profileIMG.contentMode = .scaleAspectFill
        profileIMG.clipsToBounds = true
        profileIMG.layer.cornerRadius = 30
        profileIMG.layer.masksToBounds = true
        
        
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
