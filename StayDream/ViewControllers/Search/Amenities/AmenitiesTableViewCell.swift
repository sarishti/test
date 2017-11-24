//
//  AmenitiesTableViewCell.swift
//  StayDream
//
//  Created by Sharisti on 23/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class AmenitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAmenitie: UIImageView!
    @IBOutlet weak var lblAmenitieName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // set content on cell
    func setContentOfCell(imageName: String, amenitieName: String) {
         imgAmenitie.image = UIImage(named:imageName)
        lblAmenitieName.text = amenitieName
    }

}
