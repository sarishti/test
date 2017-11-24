//
//  PropertyDetailViewController.swift
//  StayDream
//
//  Created by Sharisti on 22/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos

class PropertyDetailViewController: UIViewController, PropertyAPI, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GMSMapViewDelegate {

    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var constraintOuterView: NSLayoutConstraint!
    @IBOutlet weak var btnAmenitieCount: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constarintHeightDescText: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightDescView: NSLayoutConstraint!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblCheckOutTime: UILabel!
    @IBOutlet weak var lblCheckInTime: UILabel!
    @IBOutlet weak var lblLongDesc: UILabel!
    @IBOutlet weak var lblBedCount: UILabel!
    @IBOutlet weak var lblBedroomCount: UILabel!
    @IBOutlet weak var lblBathroomCount: UILabel!
    @IBOutlet weak var lblAccommodateCount: UILabel!
    @IBOutlet weak var lblPropertyDesc: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPropertyname: UILabel!
    var propertySelectedObject: PropertyList? // used so that previous data can fill in new model
    var objProperty: PropertyList?
    //variable
    var arrAmentiesToDisplay = [String]()
    let identifier = "AmenitiesCell"
    let constraintHeightOfDescView: CGFloat = 59
    let marginOfTextView: CGFloat = 38
    var currentZoom: CGFloat = 10.0
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.tabBarController?.tabBar.isHidden = true
        self.detailOfProperty()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Outlet Action

    @IBAction func btnBackTapped(_ sender: Any) {
        self.popViewController(animated: true)
    }

    @IBAction func btnZoomTapped(_ sender: Any) {
        guard let objProperty = self.objProperty else {
            return
        }
        currentZoom = currentZoom + 1
        zoominOutMap(currentZoom, objProperty: objProperty)
    }
    @IBAction func btnReviewTapped(_ sender: Any) {
    }
    @IBAction func btnBookTapped(_ sender: Any) {
    }
    // MARK: Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.arrAmentiesToDisplay.count > 4 ? 4 : self.arrAmentiesToDisplay.count
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? AmenitiesCollectionViewCell, self.arrAmentiesToDisplay.isIndexWithinBound(index: indexPath.row) else {
            return UICollectionViewCell()
        }
        let imageAminitie = self.arrAmentiesToDisplay[indexPath.row]
        cell.setContent(key:imageAminitie)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width - 106 // 20 margin both end 38 space of button
        let cellWidth = Float((screenWidth / 4.0)) //
        //Need 4 cell at a time in horizontal
        let size = CGSize(width: CGFloat(cellWidth), height: CGFloat(38)) // height of collection view cell 38
        return size
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Property.showAmenities.rawValue {
            if let destinationVC = segue.destination as? AmenitiesViewController {
                destinationVC.arrAmentiesToDisplay =  self.arrAmentiesToDisplay
            }
        }
    }

}
