//
//  AmenitiesCollectionViewCell.swift
//  StayDream
//
//  Created by Sharisti on 23/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class AmenitiesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgAmenities: UIImageView!

    // MARK: Set the content on cell
    func setContent(key: String) {
        imgAmenities.image = UIImage(named:key)

    }

}
