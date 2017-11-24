//
//  SignUpEmailViewController.swift
//  StayDream
//
//  Created by Sharisti on 23/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import SwiftValidator

class SignUpEmailViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, UserAPI {

    // MARK: Outlet
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailAlert: UILabel!

    /// Validator initialize
    var validator = Validator()
    var userObj = User()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
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
            signUpEmailVerify()
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
        self.changeNavBarAppearanceLight()

    }
    // MARK: Outlet action

    @IBAction func btnVerifyCodeTapped(_ sender: Any) {
        self.view.endEditing(true)
        validator.validate(self)

    }
    @IBAction func btnBackTapped(_ sender: Any) {
         self.popViewController(animated: true)
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
    func signUpEmailVerify() {
        Configuration.customHeaders[AppConstants.languageKey]  = AppUtility.getValueFromUserDefaultsForKey(AppConstants.languageDefaultKey) as? String
        var emailObj = EmailToken()
        emailObj.email = txtEmail.text!
        self.verifyEmail(emailObj) { (responseData) in

            guard let codeSuccess = responseData?.response as? Dictionary<String, Any> else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }

            if let extraKey = codeSuccess[AppConstants.extrasKey] as? [String:Any], let messageOfSuccess = extraKey[AppConstants.messageKey] as? String {
                self.userObj.userEmailId = emailObj.email
                self.showAlertWithAction(messageOfSuccess:messageOfSuccess)
            }
        }
    }

    // Pop the screen afetr success message
    func showAlertWithAction(messageOfSuccess: String) {
        let alertController = UIAlertController(title: "", message: messageOfSuccess, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OkTitle".localized, style: .cancel) { (_) in
             self.userObj.userEmailId = self.txtEmail.text
            self.performSegue(withIdentifier: StoryboardSegue.Main.showVerify.rawValue, sender: self)
        }
        alertController.addAction(okAction)

        AppUtility.appDelegate()?.window?.rootViewController?.present(alertController, animated: true, completion: {})
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Main.showVerify.rawValue {
              if let destinationVC = segue.destination as? SignUpVerifyViewController {
                destinationVC.userObj = self.userObj
            }
        }
    }

}
