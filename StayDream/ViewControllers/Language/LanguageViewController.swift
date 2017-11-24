//
//  LanguageViewController.swift
//  StayDream
//
//  Created by Sharisti on 23/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Variable and array
    var languageType = Enums.LanguageType.english.rawValue
    let arrLanguageName = ["English", "Français", "Español", "中文"]
    let arrLanguageImage = ["ic_english", "ic_franch", "ic_spanish", "ic_chines"]
    let identifierLanguage = "LanguageTableViewCell"
    var previousIndexPath: IndexPath?
    var currentIndexPath: IndexPath = IndexPath(row: Enums.LanguageType.english.rawValue, section: 0)
    // MARK: Outlet
    @IBOutlet weak var tblView: UITableView!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setNavBarHide(hide: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLanguageName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifierLanguage, for: indexPath) as? LanguageTableViewCell, arrLanguageName.isIndexWithinBound(index: indexPath.row), arrLanguageImage.isIndexWithinBound(index: indexPath.row)  else {
            return UITableViewCell()
        }
        cell.setContentOfCell(nameLanguage:arrLanguageName[indexPath.row], imgLanguage:arrLanguageImage[indexPath.row], isSelectedIndex: indexPath.row == Enums.LanguageType.english.rawValue)
            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentCell =  tableView.cellForRow(at: indexPath) as? LanguageTableViewCell, self.arrLanguageImage.isIndexWithinBound(index: indexPath.row) else {
            print( "arrLanguageImage is nil or index is out of bound")
            return
        }

        // On select particular cell the image will update
        previousIndexPath = currentIndexPath
        currentIndexPath = indexPath
        let previousCell =  previousIndexPath != nil ? tableView.cellForRow(at: previousIndexPath!):UITableViewCell()

        // if same one selected then it will disable the selection
        if previousIndexPath != currentIndexPath {
             currentCell.btnRadio.isSelected = true
            if let previousLanguageCell = previousCell as? LanguageTableViewCell {
                previousLanguageCell.btnRadio.isSelected = false
            }
        }
        self.languageType = indexPath.row

    }
    // MARK: Outlet Action

    @IBAction func btnContinueTapped(_ sender: Any) {
        AppUtility.setValueToUserDefaultsForKey(AppConstants.isDisplayLanguage, value: true as AnyObject)
        AppUtility.setValueToUserDefaultsForKey(AppConstants.languageDefaultKey, value: AppUtility.getLanguageCode(language: self.languageType) as AnyObject)
        self.performSegue(withIdentifier: StoryboardSegue.Main.showLoginOption.rawValue, sender: self)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
