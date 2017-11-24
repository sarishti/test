//
//  SignUpVerifyViewController.swift
//  StayDream
//
//  Created by Sharisti on 24/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import SwiftValidator

class SignUpVerifyViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, UserAPI {
    // MARK: Outlet function
    @IBOutlet weak var txtVerify: TextFieldLeftImage!
    @IBOutlet weak var lblVerifyAlert: UILabel!

    /// Validator initialize
    var validator = Validator()
    var userObj: User?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
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
        validator.registerField(txtVerify,
                                errorLabel: lblVerifyAlert,
                                rules: [RequiredRule(message: "VerifyError".localized)
            ])

    }

    // MARK: ValidationDelegate methods

    /**
     Validation successfully checked delegate method
     */
    func validationSuccessful() {
        if (lblVerifyAlert.text?.isEmpty)! {
            signUpCodeVerify()
        } else {

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
            if (txtVerify.text?.isEmpty)! {  txtVerify.setBorder(with: #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1529411765, alpha: 1))}

        }
    }
    // MARK: View initialization
    func initializeView() {
        self.registerFieldsForValidations()
    }

    // MARK: Outlet Actions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.popViewController(animated: true)
    }

    @IBAction func btnVerifyTapped(_ sender: Any) {
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
        self.validateFields(textField: txtVerify, lblAlert: lblVerifyAlert, error: "")
    }

    // MARK: Web service
    func signUpCodeVerify() {
        guard let object = self.userObj, let otpValue  = object.userEmailId else {
            return
        }
        Configuration.customHeaders[AppConstants.languageKey]  = AppUtility.getValueFromUserDefaultsForKey(AppConstants.languageDefaultKey) as? String
        var emailObj = EmailToken()
        emailObj.email = otpValue
        emailObj.otp = Int(self.txtVerify.text!)
        self.verifyOtp(emailObj) { (responseData) in

            guard let codeSuccess = responseData?.response as? Dictionary<String, Any> else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }
            if let extraKey = codeSuccess[AppConstants.extrasKey] as? [String:Any], let _ = extraKey[AppConstants.messageKey] as? String {
                 self.performSegue(withIdentifier: StoryboardSegue.Main.showPassword.rawValue, sender: self)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Main.showPassword.rawValue {
            if let destinationVC = segue.destination as? SignUpPasswordViewController, let objUser = self.userObj {
                destinationVC.userObj = objUser
            }
        }
    }

}
