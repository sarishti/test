//
//  SearchView+TableViewExtension.swift
//  StayDream
//
//  Created by Sharisti on 08/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: table View Delegate
    // MARK: Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrProperty.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifierSearch, for: indexPath) as? SearchCellTableViewCell, arrProperty.isIndexWithinBound(index: indexPath.row)  else {
            return UITableViewCell()
        }
        cell.contentOnCell(objProperty: arrProperty[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageHeight = (UIScreen.main.bounds.size.width - 40)/2.20 // 2.2 is ratio of image and 40 is margin left right
        return imageHeight + imageMargin

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrProperty.isIndexWithinBound(index: indexPath.row) {
            let objectProperty = arrProperty[indexPath.row]
            self.objectSelectedProperty = objectProperty
            self.performSegue(withIdentifier: StoryboardSegue.Property.showPropertyDetail.rawValue, sender: self)
        }

    }

}
