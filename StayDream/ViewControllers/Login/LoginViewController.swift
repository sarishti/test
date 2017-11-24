//
//  LoginViewController.swift
//  StayDream
//
//  Created by Sharisti on 23/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import SwiftValidator

class LoginViewController: UIViewController, ValidationDelegate, UITextFieldDelegate, UserAPI {

    // MARK: Outlet
    @IBOutlet weak var lblPswdAlert: UILabel!
    @IBOutlet weak var txtEmail: TextFieldLeftImage!
    @IBOutlet weak var lblEmailAlert: UILabel!
    @IBOutlet weak var txtPswd: TextFieldLeftImage!

    /// Validator initialize
    var validator = Validator()
    var btnPswd = UIButton()
    // MARK: Life Cycle
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
        validator.registerField(txtEmail, errorLabel: lblEmailAlert, rules: [RequiredRule(message: "EmailError".localized)])
        validator.registerField(txtPswd, errorLabel: lblPswdAlert, rules: [RequiredRule(message: "PasswordError".localized)])

    }

    // MARK: ValidationDelegate methods

    /**
     Validation successfully checked delegate method
     */
    func validationSuccessful() {
        if (lblPswdAlert.text?.isEmpty)! && (lblEmailAlert.text?.isEmpty)! {
            print("Member Info")
            signInService()
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
            if (txtPswd.text?.isEmpty)! {  txtPswd.setBorder(with: #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1529411765, alpha: 1))}
            if (txtEmail.text?.isEmpty)! {  txtEmail.setBorder(with: #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1529411765, alpha: 1))}
        }
    }
    // MARK: View initialization
    func initializeView() {
         self.changeNavBarAppearanceLight()
        self.setNavBarHide(hide: false)
        self.registerFieldsForValidations()
         btnPswd = AppUtility.getRightButton(with: #imageLiteral(resourceName: "ic_eyes_close"))
        btnPswd.addTarget(self, action:#selector(self.buttonClicked(_:)), for: .touchUpInside)
        txtPswd.rightViewMode = .always
        txtPswd.rightView = btnPswd
        if let emailId = AppUtility.getValueFromUserDefaultsForKey(AppConstants.userEmailDefaultKey) as? String {
            self.txtEmail.text = emailId
            lblEmailAlert.text = ""
        }
    }

    @objc private func buttonClicked(_ sender: UIButton?) {
        if !(sender?.isSelected)! {
            sender?.isSelected = true
            txtPswd.isSecureTextEntry = false
            btnPswd.setImage(#imageLiteral(resourceName: "ic_eyes"), for: .normal)
        } else {
            sender?.isSelected = false
            txtPswd.isSecureTextEntry = true
            btnPswd.setImage(#imageLiteral(resourceName: "ic_eyes_close"), for: .normal)
        }

    }
    // MARK: Outlet Action

    @IBAction func btnLogInTapped(_ sender: Any) {
        self.view.endEditing(true)
        validator.validate(self)
    }

    @IBAction func btnForgotTapped(_ sender: Any) {
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
        switch textField {
        case txtPswd:
            return newLength <= AppConstants.lengthTwelve
        case txtEmail:
            return newLength <= AppConstants.lengthFifty
        default:
            break
        }
        return newLength <= AppConstants.lengthFifty
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        var errorText = ""
        switch textField {
        case txtPswd:
            self.validateFields(textField: txtPswd, lblAlert: lblPswdAlert, error: errorText)
        case txtEmail:
            if !(textField.text?.isEmpty)! && !AppUtility.validateEmail(emailStr: txtEmail.text!) {
                errorText = "Invalid".localized
            }
            self.validateFields(textField: txtEmail, lblAlert: lblEmailAlert, error: errorText)
        default:
            break
        }

    }
    func fillModel() -> User {
        var userObj = User()
            userObj.userEmailId = self.txtEmail.text
            userObj.password = self.txtPswd.text
            return userObj

    }
    // MARK: Web service
    func signInService() {
        Configuration.customHeaders[AppConstants.languageKey]  = AppUtility.getValueFromUserDefaultsForKey(AppConstants.languageDefaultKey) as? String
        let objectUser = fillModel()
        self.signIn(objectUser) { (responseData) in
            guard let userObject = responseData?.response, let token = userObject.accessToken, let userEmail = userObject.userEmailId else {
                AppUtility.showAlert("", message: (responseData?.message)!, delegate: self)
                return
            }
            AppUtility.setValueToUserDefaultsForKey(AppConstants.userEmailDefaultKey, value: userEmail as AnyObject)
            KeychainWrapper.standard.set(userObject, forKey: AppConstants.userTokenKeyChain)
            Configuration.customHeaders["Authorization"] = "Bearer \(token)"
            print("userObject token Save: \(token)")
            self.changeNavBarAppearanceLight(color:#colorLiteral(red: 0.4823529412, green: 0.3176470588, blue: 0.7647058824, alpha: 1))
             AppUtility.appDelegate()?.window?.rootViewController = StoryboardScene.Property.initialScene.instantiate()
        }
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
