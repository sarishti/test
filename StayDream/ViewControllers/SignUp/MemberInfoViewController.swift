//
//  MemberInfoViewController.swift
//  StayDream
//
//  Created by Sharisti on 24/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit

class MemberInfoViewController: UIViewController, UserAPI, UITextFieldDelegate {

    // MARK: Variable
     var userObj: User?
  var  strServerDate =  ""
    // MARK: Outlet
    @IBOutlet weak var btnEmailSelection: UIButton!
    @IBOutlet weak var btnCorperate: UIButton!
    @IBOutlet weak var btnIndividual: UIButton!
    @IBOutlet weak var txtAliasReview: TextFieldLeftImage!
    @IBOutlet weak var txtDob: TextFieldLeftImage!
    @IBOutlet weak var txtMobile: TextFieldLeftImage!
    @IBOutlet weak var txtHomeNumber: TextFieldLeftImage!
    @IBOutlet weak var txtCountry: TextFieldLeftImage!
    @IBOutlet weak var txtZip: TextFieldLeftImage!
    @IBOutlet weak var txtCity: TextFieldLeftImage!
    @IBOutlet weak var txtAddress3: TextFieldLeftImage!
    @IBOutlet weak var txtAddress2: TextFieldLeftImage!
    @IBOutlet weak var txtAddress: TextFieldLeftImage!
    @IBOutlet weak var txtCompanyname: TextFieldLeftImage!
    @IBOutlet weak var txtLastName: TextFieldLeftImage!
    @IBOutlet weak var txtMiddleName: TextFieldLeftImage!
    @IBOutlet weak var txtFirstName: TextFieldLeftImage!
    @IBOutlet var toolBarPickerVw: UIToolbar!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var txtRegionCode: TextFieldLeftImage!
    @IBOutlet weak var vwSelection: UIView!
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        print("userObj : \(String(describing: userObj))")
        // Do any additional setup after loading the view.
    }
    func initializeView() {
        vwSelection.layer.borderColor = #colorLiteral(red: 0.5699723363, green: 0.1442027688, blue: 0.6577451825, alpha: 1)
        self.txtDob.inputView = self.datePicker
        self.txtDob.inputAccessoryView = self.toolBarPickerVw
        setMinimumMaximumDateOfPicker()
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Outlet action

    @IBAction func btnSignUpTapped(_ sender: Any) {
        if txtFirstName.isBlank || txtLastName.isBlank || txtAddress.isBlank || txtZip.isBlank || txtDob.isBlank || txtAliasReview.isBlank {
            AppUtility.showAlert("", message: "MandatoryError".localized, delegate: self)
        } else if btnCorperate.isSelected && txtCompanyname.isBlank {
            AppUtility.showAlert("", message: "MandatoryError".localized, delegate: self)
        } else if !btnAgree.isSelected {
            AppUtility.showAlert("", message: "AgreeTerms".localized, delegate: self)
        } else {
            signUpEmailVerify()
        }
    }

    @IBAction func btnBackTapped(_ sender: Any) {
        self.popViewController(animated: true)
    }

    @IBAction func btnMemberDetailTapped(_ sender: Any) {
    }
    @IBAction func btnServiceTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func btnOnEmailTapped(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
    }
    @IBAction func btnCoperateTapped(_ sender: UIButton) {
        selectionAction(sender: sender)
    }
    @IBAction func btnIndividualTapped(_ sender: UIButton) {
        selectionAction(sender: sender)
    }
    /// On selection display the button highlighted
    ///
    /// - Parameter sender: button
    func selectionAction(sender: UIButton) {
        let selectButton = sender == btnIndividual ? btnIndividual : btnCorperate
        let unselectButton = sender != btnIndividual ? btnIndividual : btnCorperate
        txtCompanyname.placeholder = sender == btnCorperate ? "Comapny Name*" : "Comapny Name"
        selectButton?.isSelected = true
        unselectButton?.isSelected = false
        selectButton?.backgroundColor = #colorLiteral(red: 0.5699723363, green: 0.1442027688, blue: 0.6577451825, alpha: 1)
        selectButton?.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        unselectButton?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        unselectButton?.setTitleColor(#colorLiteral(red: 0.5699723363, green: 0.1442027688, blue: 0.6577451825, alpha: 1), for: .normal)
    }
    /// Fill model with object
    ///
    /// - Returns: return user object
    func fillModel() -> User? {
        if let _ = self.userObj {
            self.userObj?.firstName = (self.txtFirstName.text?.isEmpty)! ? nil : self.txtFirstName.text
            self.userObj?.lastName = self.txtLastName.text
            self.userObj?.middleName = self.txtMiddleName.text
            self.userObj?.companyName = self.txtCompanyname.text
            self.userObj?.addressLine1Text = self.txtAddress.text
            self.userObj?.addressLine2Text = (self.txtAddress2.text?.isEmpty)! ? nil : self.txtAddress2.text
            self.userObj?.addressLine3Text = self.txtAddress3.text
            self.userObj?.mobilePhoneNumber = self.txtMobile.text
            self.userObj?.corporateIndicator = btnCorperate.isSelected
            self.userObj?.addressCityName = (self.txtCity.text?.isEmpty)! ? nil : self.txtCity.text
            self.userObj?.addressRegionalAreaCode = (self.txtRegionCode.text?.isEmpty)! ? nil : self.txtRegionCode.text
            self.userObj?.addressPostalCode = self.txtZip.text
            self.userObj?.mainPhoneNumber = self.txtHomeNumber.text
            self.userObj?.addressCountryName = (self.txtCountry.text?.isEmpty)! ? nil : self.txtCountry.text
            self.userObj?.birthDate = strServerDate
            self.userObj?.aliasName = self.txtAliasReview.text
            self.userObj?.marketingCommunicationsConsentIndicator = btnEmailSelection.isSelected
            return self.userObj
        }
        return nil

    }
    // MARK: Picker
    /// Set the maximum date of yesterday
    func setMinimumMaximumDateOfPicker() {
        self.datePicker.maximumDate = Date().addingTimeInterval(-(60 * 60 * 24))
        // for one day time interval set 60 * 60 * 24
    }

    /// Set value of date picker on text field
    func setSelectedDateOfPicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = NSLocale(localeIdentifier: AppConstants.localIdentifier) as Locale!
        let strSelectedDate = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = AppConstants.dateFormatServer
        strServerDate = dateFormatter.string(from: datePicker.date)
        self.txtDob.text = strSelectedDate

    }
    // MARK: Done and Cancel of Picker
    /// Button done tapped
    ///
    /// - Parameter sender: done button
    @IBAction func btnDoneTapped(_ sender: AnyObject) {
        setSelectedDateOfPicker()
        txtDob.resignFirstResponder()
    }

    /// Button cancel tapped
    ///
    /// - Parameter sender: cancel button
    @IBAction func btnCancelTapped(_ sender: AnyObject) {
        txtDob.resignFirstResponder()
    }
    // MARK: Web service
    func signUpEmailVerify() {
        guard let objectUser = fillModel() else {
            return
        }
        self.signUp(objectUser) { (responseData) in
            guard let userObject = responseData?.response, let token = userObject.accessToken, let userEmail = userObject.userEmailId else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }
            AppUtility.setValueToUserDefaultsForKey(AppConstants.userEmailDefaultKey, value: userEmail as AnyObject)
            KeychainWrapper.standard.set(userObject, forKey: AppConstants.userTokenKeyChain)
             Configuration.customHeaders["Authorization"] = "Bearer \(token)"
            self.changeNavBarAppearanceLight(color:#colorLiteral(red: 0.4823529412, green: 0.3176470588, blue: 0.7647058824, alpha: 1))
            AppUtility.appDelegate()?.window?.rootViewController = StoryboardScene.Property.initialScene.instantiate()
            print("user Token:  \(token)")
        }
    }
    // MARK: Text Field delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        switch textField {
        case txtLastName, txtMobile, txtHomeNumber:
            return newLength <= 30
        case txtFirstName, txtMiddleName, txtAliasReview:
            return newLength <= AppConstants.lengthTwently
        case txtCompanyname, txtAddress, txtAddress2, txtAddress3, txtCity, txtRegionCode, txtCountry:
            return newLength <= 40
        case txtZip:
            return newLength <= 15

        default:
            break
        }
        return newLength <= AppConstants.lengthFifty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
