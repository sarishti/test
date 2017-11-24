//
//  AmenitiesViewController.swift
//  StayDream
//
//  Created by Sharisti on 23/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class AmenitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlet
    let identifier = "AmenitiesTableViewCell"
       var arrAmentiesToDisplay = [String]()
    var plistData: [String: Any]?
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAmentiesFromPlist()
        // Do any additional setup after loading the view.
    }
    func getAmentiesFromPlist() {
        if let fileUrl = Bundle.main.url(forResource: "Amenities", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] { // [String: Any] which ever it is
                plistData = result
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Table view delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAmentiesToDisplay.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? AmenitiesTableViewCell, self.arrAmentiesToDisplay.isIndexWithinBound(index: indexPath.row), let dictPlist = self.plistData else {
            return UITableViewCell()
        }
        cell.setContentOfCell(imageName: self.arrAmentiesToDisplay[indexPath.row], amenitieName: dictPlist[self.arrAmentiesToDisplay[indexPath.row]] as? String ?? "")
        return cell
    }

    @IBAction func btnBackTapped(_ sender: Any) {
        self.popViewController(animated: true)
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
