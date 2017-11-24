//
//  LanguageTableViewCell.swift
//  StayDream
//
//  Created by Sharisti on 23/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    // MARK: Closure
    var  btnLanguageTapped: ((LanguageTableViewCell) -> Void)?
    // MARK: Outlet
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewLanguage: UIImageView!
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: Set the UI of language
    func setContentOfCell(nameLanguage: String, imgLanguage: String, isSelectedIndex: Bool) {
        lblName.text = nameLanguage
        imgViewLanguage.image = UIImage(named:imgLanguage)
        btnRadio.isSelected = isSelectedIndex
    }
    // MARK: Outlet action

    @IBAction func btnLanguage(_ sender: Any) {
        btnLanguageTapped?(self)
    }
}
