//
//  SearchView+TableViewExtension.swift
//  StayDream
//
//  Created by Sharisti on 08/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
import GoogleMaps

extension PropertyDetailViewController {
    // MARK: Custom function
    // current model will fill with prevoius data like distance cost etc
    func fillModelWithData() {
        guard let objectPreviousProperty = propertySelectedObject, let _ = self.objProperty else {
            return
        }
        self.objProperty?.distance = objectPreviousProperty.distance
        self.objProperty?.billingCurrencyCode = objectPreviousProperty.billingCurrencyCode
        self.objProperty?.roomRateAmount = objectPreviousProperty.roomRateAmount
        self.objProperty?.ratingNumber = objectPreviousProperty.ratingNumber
    }

    func initializeViewData() {
        guard let objProperty = self.objProperty else {
            return
        }
        setTitleView(objProperty: objProperty)
        lblReviewCount.text = "\(objProperty.reviewCount ?? 0)" + "whiteSpace".localized + "Reviews".localized
        lblBedCount.text = "\(objProperty.bedCount ?? 0)"
        lblBedroomCount.text = "\(objProperty.bedroomCount ?? 0)"
        lblAccommodateCount.text = "\(objProperty.accommodateCount ?? 0)"
        lblBathroomCount.text = "\(objProperty.bathroomCount ?? 0)"
        lblCheckInTime.text = objProperty.checkInAfterTime ?? "13:00:00" // default
        lblCheckOutTime.text = objProperty.checkOutBeforeTime ?? "11:00:00"
        self.arrAmentiesToDisplay.removeAll()
        self.dispalyTheAmenities(objProperty: objProperty)
        self.setMapWithLatLong(objProperty: objProperty)

    }

    func setTitleView(objProperty: PropertyList) {
        lblPropertyname.text = objProperty.buildingTagName ?? ""
        let currencyCode = objProperty.billingCurrencyCode ?? ""
        let rateAmount = objProperty.roomRateAmount ?? 0.0
        let viewCodeStr = FunctionalUtility.viewTypeCodeString(code: objProperty.viewTypeCode ?? "")
        lblPropertyDesc.text = (objProperty.propertyShortDescription ?? "" ) + ", " + viewCodeStr
        ratingView.rating = Double(objProperty.ratingNumber ?? 0)

        lblRating.text = "\(String(describing: objProperty.ratingNumber ?? 0))"
        let lightContentStr = "From".localized + currencyCode
        let boldContentStr = "dollar".localized + "\(rateAmount)" + "perNight".localized
        lblCost.attributedText = lightContentStr.changeSusbstring(toColor: #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0, alpha: 1), toFont: FontFamily.Tahoma.normal.font(size: 11), inRange: NSRange.init(location: 0, length: lightContentStr.length)) + boldContentStr.changeSusbstring(toColor: #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0, alpha: 1), toFont: FontFamily.Tahoma.bold.font(size: 11), inRange: NSRange.init(location: 0, length: boldContentStr.length))
        lblDistance.text = "\(objProperty.distance ?? 0)" + "Km".localized
        lblLongDesc.text = objProperty.propertyLongDescription ?? ""
        if (lblLongDesc.text?.isEmpty)! {
            constraintHeightDescView.constant = 0
        } else {
            constraintHeightDescView.constant =  constarintHeightDescText.constant + marginOfTextView // top and bottom space
        }
        constraintOuterView.constant = constraintOuterView.constant - constraintHeightOfDescView + constraintHeightDescView.constant
        self.view.layoutIfNeeded()
    }

    func setMapWithLatLong(objProperty: PropertyList) {
        if let latitute = Double(objProperty.buildingLatitudeDecimalDegrees ?? "0"), let longtitute = Double(objProperty.buildingLongitudeDecimalDegrees ?? "0") {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(latitute, longtitute)
            marker.map = mapView
            self.zoominOutMap(self.currentZoom, objProperty: objProperty)
        }
    }

    /* Amenities which are true we need to dispaly that only
     Find the amenities in dic then get only those which are true
     */
    func dispalyTheAmenities(objProperty: PropertyList) {
        do {
            let dictAmentities = try objProperty.allAmenities()
            for (key, value) in dictAmentities {
                if let indicator = value as? Bool {
                    if indicator == true {
                        self.arrAmentiesToDisplay.append(key)

                    }
                }
            }
        } catch {
            print("Dim background error")
        }
        btnAmenitieCount.isHidden = self.arrAmentiesToDisplay.count < 5
        if self.arrAmentiesToDisplay.count > 4 {
            btnAmenitieCount.setTitle("+\(self.arrAmentiesToDisplay.count - 4)", for: .normal)
        }
        self.collectionView.reloadData()
    }
    // MARK: MAp View
    func zoominOutMap(_ level: CGFloat, objProperty: PropertyList) {
        if let latitute = Double(objProperty.buildingLatitudeDecimalDegrees ?? "0"), let longtitute = Double(objProperty.buildingLongitudeDecimalDegrees ?? "0") {
            let camera = GMSCameraPosition.camera(withLatitude: latitute, longitude: longtitute, zoom: Float(level))
            //latitude, longitude like :31.230416 and 121.473701.
            //            mapView.isMyLocationEnabled = true
            mapView.camera = camera
        }
    }

    // MARK: Web service
    // call web service
    func detailOfProperty() {
        guard let objectProperty = propertySelectedObject, let idProperty = objectProperty.id else {
            return
        }
        self.propertyDetail(idProperty) { (responseData) in
            guard let objPropertyList = responseData?.response else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }
            self.objProperty = objPropertyList
            self.fillModelWithData()
            self.initializeViewData()
        }

    }
}
