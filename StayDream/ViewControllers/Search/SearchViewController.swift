//
//  SearchViewController.swift
//  StayDream
//
//  Created by Sharisti on 27/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import CoreLocation

//Completion handler to stop particular loader
typealias CompletionHandlerForLoadMore = (_ complete: Bool) -> Void

class SearchViewController: UIViewController, PropertyAPI, UITextFieldDelegate, UIScrollViewDelegate {

    // MARK: Outlet
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var txtAnyTime: TextFieldLeftImage!
    @IBOutlet weak var txtNearMe: TextFieldLeftImage!
    @IBOutlet weak var constraintHeightNearMe: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightTime: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightTopVw: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    var imageMargin: CGFloat = 105 // 47 description view, cost view 38 and 10 bottom margin
    var isTime: Bool = false
    var isLocationSelected: Bool = false
    var isDateSelected: Bool = false
    var choosenLocation: CLLocationCoordinate2D?
    var startDate: String = ""
    var endDate: String = ""
    var objectSelectedProperty: PropertyList?
    // variable
    var pageNumber: Int = 1
    let identifierSearch = "SearchCellTableViewCell"
    var arrProperty = [PropertyList]()
    var barLeftItem = UIBarButtonItem()
    var barRightItem = UIBarButtonItem()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    // deinit function
    deinit {
        if let tblViewObj = self.tblView {
            tblViewObj.dg_removePullToRefresh()
        }
    }

    //MARK:  initialize view
    func initializeView() {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: txtNearMe.frame.size.height))
        txtNearMe.rightViewMode = .always
        txtNearMe.rightView = view
        self.lblNoRecord.isHidden =  true
        // initalize button but display and hight as per requirement
        barLeftItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "arow_up"), style: .done, target: self, action: #selector(SearchViewController.barItemTappedAction(_:)))
        barRightItem =  UIBarButtonItem.init(title: "ClearAll".localized, style: .plain, target: self, action: #selector(SearchViewController.barClearTappedAction(_:)))
        self.expalnd(isNearMeSelected: false)
        self.callServiceInitially()
        self.setPullToRefreshOnVideoTable()
        setInfiniteScrollOnTable()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tblView.fixedPullToRefreshViewForDidScroll()
    }
    /// Set the pull to refersh
    func setPullToRefreshOnVideoTable() {
        /// Set the loading view's indicator color
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.gray

        /// Add handler
        tblView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.pageNumber = 1
            self?.tblView.hasMoreData = true
            self?.callPropertyService(completionHandlerForLoadMore: { (_) -> Void in
                self?.tblView.stopPullToRefreshLoader()
            })
            }, loadingView: loadingView)

        /// Set the background color of pull to refresh
        tblView.dg_setPullToRefreshFillColor(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1))
        tblView.dg_setPullToRefreshBackgroundColor(tblView.backgroundColor!)
    }

    // MARK: - Infinite scrolling
    /**
     Set reuseable component Infinite scroller handler
     */
    func setInfiniteScrollOnTable() {
        self.tblView.addPushRefreshHandler({ [weak self] in
            // Send the next starting offset.
            self?.loadMoreVideoData()

        })
    }
    // MARK: - Load more for videos
    /**
     Load more videos
     - parameter nil
     */
    func loadMoreVideoData() {
        callPropertyService(completionHandlerForLoadMore: { (_) -> Void in
            self.tblView.stopInfiniteScrollLoader()
        })
    }

    // MARK: Webservices

    /// Call the service to get all sessions list
    func callPropertyService(completionHandlerForLoadMore: @escaping CompletionHandlerForLoadMore) {
        var propertyObj = Property()
        let latitute = LocationService.sharedInstance.currentLocation?.coordinate.latitude
        let longtitute = LocationService.sharedInstance.currentLocation?.coordinate.longitude
        propertyObj.latitude = (isLocationSelected ? choosenLocation?.latitude : latitute)?.rounded(toPlaces: 5)
        propertyObj.longitude = (isLocationSelected ? choosenLocation?.longitude : longtitute)?.rounded(toPlaces: 5)
        propertyObj.startDate = isDateSelected ? startDate : nil
        propertyObj.endDate = isDateSelected ? endDate : nil

        self.propertyList(self.pageNumber, body: propertyObj) { (responseData) in
            guard let objProperty = responseData?.response else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }

            self.pageNumber == 1 ? self.arrProperty.removeAll() : print("no need")
            if let arrResult = objProperty.results {
                for objProperty in arrResult {
                    self.arrProperty.append(objProperty)
                }

            }
//
//            self.arrProperty = objProperty.results ?? [PropertyList]()
            //no record label on basis of check
            self.arrProperty.count > 0 && objProperty.next != nil ? (self.pageNumber = self.pageNumber + 1) : print("no need")
            self.lblNoRecord.isHidden = self.arrProperty.count > 0
            // complete function
            completionHandlerForLoadMore(true)
            self.tblView.reloadData()
        }

    }

    func callServiceInitially() {
        self.pageNumber = 1
        callPropertyService(completionHandlerForLoadMore: { (_) -> Void in
        })
    }

    // MARK: Text Field delegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case txtNearMe:
            if !isTime {
            self.expalnd(isNearMeSelected:true) // means expand
            } else {
                 self.performSegue(withIdentifier: StoryboardSegue.Property.showLocation.rawValue, sender: self)
            }
        case txtAnyTime:
             self.performSegue(withIdentifier: StoryboardSegue.Property.showDates.rawValue, sender: self)
            return false
        default:
            break
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // Custom
    func expalnd(isNearMeSelected: Bool) {
        var margin: CGFloat = 30 // margin top bottom and in/w
        var height: CGFloat = 0
        if isNearMeSelected {
            isTime = true
            height = 40 // height of text view
            margin = 30.0
            self.navigationItem.leftBarButtonItem = self.barLeftItem

        } else {
            isTime = false
            height = 0
            margin = 20.0
            self.navigationItem.leftBarButtonItem = nil
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.constraintHeightTime.constant = height
            self.txtAnyTime.isHidden = !self.isTime
            self.constraintHeightTopVw.constant = self.constraintHeightNearMe.constant + self.constraintHeightTime.constant + margin
        }, completion: nil)

    }
    // MARK: Bar button actions

    @objc func barItemTappedAction(_ button: UIBarButtonItem!) {
        self.expalnd(isNearMeSelected:false)
    }
    @objc func barClearTappedAction(_ button: UIBarButtonItem!) {
        self.isLocationSelected = false
        self.isDateSelected = false
         self.navigationItem.rightBarButtonItem = nil
        self.txtNearMe.text = ""
        self.txtAnyTime.text = ""
        self.callServiceInitially()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Property.showLocation.rawValue {
            if let destinationVC = segue.destination as? SearchLocationViewController {
                destinationVC.blockToNotifyLocation = { (locationCoordinate: CLLocationCoordinate2D, strSelectedLocation: String) -> Void in
                    self.isLocationSelected = true
                    self.txtNearMe.text = strSelectedLocation
                    self.choosenLocation = locationCoordinate
                    print("Chosen coordinate: \(locationCoordinate)")
                    self.callServiceInitially()
                     self.navigationItem.rightBarButtonItem = self.barRightItem

                }
            }
        } else if segue.identifier == StoryboardSegue.Property.showDates.rawValue {
            if let destinationVC = segue.destination as? SelectDatesViewController {
                destinationVC.blockToNotifySelectedDates  = {(startingDate: Date, endingDate: Date) -> Void in
                    print("startDate: \(startingDate) endDate: \(endingDate)")
                    self.isDateSelected = true
                    self.startDate = DateUtility.getStrDate(from: startingDate, format: AppConstants.dateFormatServer)
                    self.endDate =  DateUtility.getStrDate(from: endingDate, format: AppConstants.dateFormatServer)
                    self.txtAnyTime.text = "\(self.startDate)" + "to".localized + "\(self.endDate)"
                    self.callServiceInitially()
                    self.navigationItem.rightBarButtonItem = self.barRightItem
                }

            }
        } else if segue.identifier == StoryboardSegue.Property.showPropertyDetail.rawValue {
            if let destinationVC = segue.destination as? PropertyDetailViewController, let objProperty = self.objectSelectedProperty {
                destinationVC.propertySelectedObject = objProperty
            }
        }
    }

}
