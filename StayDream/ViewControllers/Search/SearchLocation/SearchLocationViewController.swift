//
//  SearchLocationViewController.swift
//  DITY

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import GooglePlaces

// Block to send the selected location to previous control
typealias SearchLocationBlock = (_ locationCoordinate: CLLocationCoordinate2D, _ strSelectedLocation: String) -> Void

class SearchLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GooglePlaceAPI {

    // MARK: Constants

    @IBOutlet weak var lblNoRecord: UILabel!
    var blockToNotifyLocation: SearchLocationBlock?
    var heightKeyboard: CGFloat?
    let topViewHeight: CGFloat = 121 //64 for navigation and 57 search view
    var viewBgHeight: CGFloat?
    // Constant fonts
    let regularFontTitle = FontFamily.Tahoma.normal.font(size: 15)
    let boldFontTitle = FontFamily.Tahoma.bold.font(size: 15)
    let regularFontSubTitle = FontFamily.Tahoma.normal.font(size: 12)
    let boldFontSubTitle = FontFamily.Tahoma.bold.font(size: 12)

    // MARK: Outlet Properties
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblVwSearch: UITableView!
    var placesClient: GMSPlacesClient?
    // Array
    var arrLocationListing = NSMutableArray()
    var arrAutocompleteQueryResults = NSMutableArray()
    // MARK: Constraint Outlet
    @IBOutlet weak var constraintTbleVwHeight: NSLayoutConstraint!

    // MARK: View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set the keyboard notification so that scroll the table view till end
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Keyboard Notification
    @objc func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            self.heightKeyboard = keyboardFrame.size.height
            // Now is stored in your heightKeyboard variable
            if self.heightKeyboard != nil && viewBgHeight != nil {
            self.constraintTbleVwHeight.constant = (viewBgHeight! - topViewHeight) -  self.heightKeyboard!
            }
        }
    }

    @objc func keyboardHide(notification: NSNotification) {
        if self.heightKeyboard != nil && viewBgHeight != nil {
            let height = self.tblVwSearch.preferredContentSizeOfTable().height > (viewBgHeight! - topViewHeight) ?  (viewBgHeight! - topViewHeight) : self.tblVwSearch.preferredContentSizeOfTable().height
             self.constraintTbleVwHeight.constant = height
        }
    }

    // MARK: Initialoze the view
    func initializeView() {
        txtSearch.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
        viewBgHeight = UIScreen.main.bounds.height
        txtSearch.becomeFirstResponder()
        self.lblNoRecord.isHidden = true
        placesClient = GMSPlacesClient()
        txtSearch.addTarget(self, action: #selector(txtSearchEdited), for: UIControlEvents.editingChanged)
    }

    // MARK: - Text edited methods
     @objc func txtSearchEdited(sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: NSCharacterSet.newlines)
        if text?.characters.count == 0 {
            self.arrAutocompleteQueryResults.removeAllObjects()
            self.arrLocationListing.removeAllObjects()
            self.tblVwSearch.isHidden =  self.arrLocationListing.count > 0 ? false :  true
            self.tblVwSearch.reloadData()
            return
        }
        // service will hit on every 3rd character
        if let charaterCount = text?.characters.count, charaterCount % 3 == 0 {
            self.autocompleteResult(searchText: text!)
        }
    }

    // MARK: - UITextField Delegate methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        return newLength <= 50
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - table View delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLocationListing.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCell", for: indexPath as IndexPath) as? SearchLocationTableViewCell, self.arrLocationListing.isIndexWithinBound(index: indexPath.row) else {
            return UITableViewCell()
        }
        // display the serached content on string
        if let strTitle = self.arrLocationListing.object(at: indexPath.row) as? String {
            cell.lblSearch.text = strTitle
        }
        return cell
    }

    // MARK: - UITableView Delegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrAutocompleteQueryResults.count <= (indexPath as NSIndexPath).row {
            return
        }
        // check the array and call service after remove element
        self.arrLocationListing.removeAllObjects()
        self.arrLocationListing.add(self.arrAutocompleteQueryResults.object(at: (indexPath as NSIndexPath).row))
        if let arr = self.arrLocationListing.mutableCopy() as? NSMutableArray {
            if let prediction = arr.object(at: 0) as? GoogleAutocompleteJSONModel, let strLocationTitle = prediction.title, let placeId = prediction.placeId {
                self.lookUpInPlaceId(placeId, selectedLocation: strLocationTitle)
            }
        }
        self.popViewController(animated: true)

    }

    // MARK: - Google Search methods
    func lookUpInPlaceId(_ placeID: String, selectedLocation: String) {
        self.placeCoordinate(placeId: placeID) { (responseData) in
            AppUtility.dismissLoaderOnView()
            guard let results = responseData else {
                AppUtility.showAlert("", message: "GoogleAPIError".localized, delegate: self)
                return
            }
            self.blockToNotifyLocation?(results.coordinate, selectedLocation)
            print(results)
        }
    }

    // api to find the autocomplete
    func autocompleteResult(searchText: String) {
        self.autoCompleteResults(searchText) { (responseData) in
           AppUtility.dismissLoaderOnView()
            guard let results = responseData else {
                AppUtility.showAlert("", message: "GoogleAPIError".localized, delegate: self)
                return
            }

            self.arrAutocompleteQueryResults.removeAllObjects()
            let arrResults: NSMutableArray = NSMutableArray()
            for prediction in results {
                arrResults.add(prediction.title ?? "")
                self.arrAutocompleteQueryResults.add(prediction)
            }
            // autocompelet result will display on array
            self.arrLocationListing = arrResults
            self.lblNoRecord.isHidden =  self.arrLocationListing.count > 0
            self.tblVwSearch.isHidden = !self.lblNoRecord.isHidden
            self.tblVwSearch.reloadData()
            print(results)
        }
    }

    // MARK: - Outlet Methods

    @IBAction func btnClearTapped(_ sender: Any) {
        self.txtSearch.text = ""
        self.view.endEditing(true)
        self.autocompleteResult(searchText: self.txtSearch.text!)
    }
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.popViewController(animated: true)
    }

}
