//
//  SignUpPasswordViewController.swift
//  StayDream
//
//  Created by Sharisti on 24/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import SwiftValidator

class SignUpPasswordViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

    // MARK: Outlet

    @IBOutlet weak var txtPswd: TextFieldLeftImage!
    @IBOutlet weak var lblConfirmAlert: UILabel!
    @IBOutlet weak var txtConfirmPswd: TextFieldLeftImage!
    @IBOutlet weak var lblPswdAlert: UILabel!
    var btnPswd = UIButton()
    var btnConfirmPswd = UIButton()

    /// Validator initialize
    var validator = Validator()
    var userObj: User?

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
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
        validator.registerField(txtPswd, errorLabel: lblPswdAlert, rules: [RequiredRule(message: "PasswordError".localized)])
        validator.registerField(txtConfirmPswd, errorLabel: lblConfirmAlert, rules: [RequiredRule(message: "PasswordError".localized)])

    }

    // MARK: ValidationDelegate methods

    /**
     Validation successfully checked delegate method
     */
    func validationSuccessful() {
        if (lblPswdAlert.text?.isEmpty)! && (lblConfirmAlert.text?.isEmpty)! {
             userObj?.password = txtPswd.text
              self.performSegue(withIdentifier: StoryboardSegue.Main.showMemberInfo.rawValue, sender: self)
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
            if (txtConfirmPswd.text?.isEmpty)! {  txtConfirmPswd.setBorder(with: #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1529411765, alpha: 1))}
        }
    }
    // MARK: View initialization
    func initializeView() {
        self.registerFieldsForValidations()
        btnPswd = AppUtility.getRightButton(with: #imageLiteral(resourceName: "ic_eyes_close"))
        btnPswd.addTarget(self, action:#selector(self.buttonClicked(_:)), for: .touchUpInside)
        txtPswd.rightViewMode = .always
        txtPswd.rightView = btnPswd
        btnConfirmPswd = AppUtility.getRightButton(with: #imageLiteral(resourceName: "ic_eyes_close"))
        btnConfirmPswd.addTarget(self, action:#selector(self.buttonClicked(_:)), for: .touchUpInside)
        txtConfirmPswd.rightViewMode = .always
        txtConfirmPswd.rightView = btnConfirmPswd
    }

    @objc private func buttonClicked(_ sender: UIButton?) {
        let txtField = sender == btnConfirmPswd ? txtConfirmPswd : txtPswd
        if !(sender?.isSelected)! {
            sender?.isSelected = true
            txtField?.isSecureTextEntry = false
            sender?.setImage(#imageLiteral(resourceName: "ic_eyes"), for: .normal)
        } else {
            sender?.isSelected = false
            txtField?.isSecureTextEntry = true
            sender?.setImage(#imageLiteral(resourceName: "ic_eyes_close"), for: .normal)
        }

    }

    // MARK: Outlet action
    @IBAction func btnBackTapped(_ sender: Any) {
        self.popViewController(animated: true)
    }
    @IBAction func btnConfirmTapped(_ sender: Any) {
        self.view.endEditing(true)
        validator.validate(self)
    }

    // MARK: Text Field delegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        return newLength <= AppConstants.lengthTwelve
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        var errorText = ""
        switch textField {
        case txtPswd:
             if !AppUtility.validatePassword(passwordStr: txtPswd.text!) {
                errorText = "PswdValidError".localized
            }
             self.validateFields(textField: txtPswd, lblAlert: lblPswdAlert, error: errorText)
        case txtConfirmPswd:
             if !AppUtility.validatePassword(passwordStr: txtConfirmPswd.text!) {
                errorText = "PswdValidError".localized
             } else if txtConfirmPswd.text != txtPswd.text {
                errorText = "InvalidMatch".localized
             }
            self.validateFields(textField: txtConfirmPswd, lblAlert: lblConfirmAlert, error: errorText)
        default:
            break
        }

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardSegue.Main.showMemberInfo.rawValue {
            if let destinationVC = segue.destination as? MemberInfoViewController, let objUser = self.userObj {
                destinationVC.userObj = objUser
            }
        }
    }

}
