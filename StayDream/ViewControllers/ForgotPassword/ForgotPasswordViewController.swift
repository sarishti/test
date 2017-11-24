//
//  ForgotPasswordViewController.swift
//  StayDream
//
//  Created by Sharisti on 30/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import SwiftValidator

class ForgotPasswordViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, UserAPI {

    @IBOutlet weak var lblEmailAlert: UILabel!
    @IBOutlet weak var txtEmail: TextFieldLeftImage!
    /// Validator initialize
    var validator = Validator()
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       self.registerFieldsForValidations()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Add validator fields
    /**
     Register the fields to swift validator
     */
    func registerFieldsForValidations() {
        validator.registerField(txtEmail,
                                errorLabel: lblEmailAlert,
                                rules: [RequiredRule(message: "EmailError".localized)
            ])

    }

    // MARK: ValidationDelegate methods

    /**
     Validation successfully checked delegate method
     */
    func validationSuccessful() {
        if (lblEmailAlert.text?.isEmpty)! {
            forgotPasswordService()
        }
    }

    /**
     Validation failed delegate method
     
     - parameter errors: arr of validation
     */
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (_, error) in errors {
            error.errorLabel?.text = error.errorMessage // works if you added error labels
            error.errorLabel?.isHidden = false
            if (txtEmail.text?.isEmpty)! {  txtEmail.setBorder(with: #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1529411765, alpha: 1))}

        }
    }
    // MARK: View initialization
    func initializeView() {
        self.setNavBarHide(hide: false)
        self.registerFieldsForValidations()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

    }
    // MARK: Action
    @IBAction func btnBackTapped(_ sender: Any) {
        self.popViewController(animated: true)
    }
    @IBAction func btnSendTapped(_ sender: Any) {
        self.view.endEditing(true)
        validator.validate(self)
    }

    // MARK: Text Field delegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        return newLength <= AppConstants.lengthFifty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        var errorText = ""
        if !(textField.text?.isEmpty)! && !AppUtility.validateEmail(emailStr: txtEmail.text!) {
            errorText = "Invalid".localized
        }
        self.validateFields(textField: txtEmail, lblAlert: lblEmailAlert, error: errorText)
    }

    // MARK: Web service
    func forgotPasswordService() {
        var userObj = User()
        userObj.userEmailId = txtEmail.text!
        self.forgotPassword(userObj) { (responseData) in
            guard let emailSuccess = responseData?.response as? Dictionary<String, Any> else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }
            if let extraKey = emailSuccess[AppConstants.extrasKey] as? [String:Any], let messageOfSuccess = extraKey[AppConstants.messageKey] as? String {
                self.showAlertWithPop(messageOfSuccess:messageOfSuccess)
            }

        }
    }
    // Pop the screen afetr success message
    func showAlertWithPop(messageOfSuccess: String) {
        let alertController = UIAlertController(title: "", message: messageOfSuccess, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OkTitle".localized, style: .cancel) { (_) in
            self.popViewController(animated: true)
        }
        alertController.addAction(okAction)

        AppUtility.appDelegate()?.window?.rootViewController?.present(alertController, animated: true, completion: {})
    }

}
