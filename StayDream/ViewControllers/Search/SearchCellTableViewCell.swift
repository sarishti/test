//
//  SearchCellTableViewCell.swift
//  StayDream
//
//  Created by Sharisti on 31/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import Cosmos

class SearchCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var vwPropertyCost: UIView!
    @IBOutlet weak var vwPropertyDesc: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var ratingVw: CosmosView!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblPropertyDesc: UILabel!
    @IBOutlet weak var lblPropertyName: UILabel!
    @IBOutlet weak var constraintHeightPropertyImg: NSLayoutConstraint!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imgProperty: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        setUIOfCell()
    }
    // MARK: Ui of cell
    func setUIOfCell() {
          ratingVw.settings.fillMode = .precise
        cellView.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)

    }
    // MARK: content on cell
    func contentOnCell(objProperty: PropertyList) {
        lblPropertyName.text = objProperty.buildingTagName ?? ""
        let currencyCode = objProperty.billingCurrencyCode ?? ""
        let rateAmount = objProperty.roomRateAmount ?? 0.0
        let viewCodeStr = FunctionalUtility.viewTypeCodeString(code: objProperty.viewTypeCode ?? "")
        lblPropertyDesc.text = (objProperty.propertyShortDescription ?? "" ) + ", " + viewCodeStr
        ratingVw.rating = Double(objProperty.ratingNumber ?? 0)

        lblRating.text = "\(String(describing: objProperty.ratingNumber ?? 0))"
        let lightContentStr = "From".localized + currencyCode
        let boldContentStr = "dollar".localized + "\(rateAmount)" + "perNight".localized
       lblCost.attributedText = lightContentStr.changeSusbstring(toColor: #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0, alpha: 1), toFont: FontFamily.Tahoma.normal.font(size: 11), inRange: NSRange.init(location: 0, length: lightContentStr.length)) + boldContentStr.changeSusbstring(toColor: #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0, alpha: 1), toFont: FontFamily.Tahoma.bold.font(size: 11), inRange: NSRange.init(location: 0, length: boldContentStr.length))
        lblDistance.text = "\(objProperty.distance ?? 0)" + "Km".localized

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
