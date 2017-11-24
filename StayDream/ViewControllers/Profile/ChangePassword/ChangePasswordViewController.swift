//
//  ChangePasswordViewController.swift
//  StayDream
//
//  Created by Sharisti on 16/11/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import UIKit
import SwiftValidator

class ChangePasswordViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

    // MARK: Outlet

    @IBOutlet weak var lblCurrentPswdTitle: UILabel!
    @IBOutlet weak var lblCurrentPswdAlert: UILabel!
    @IBOutlet weak var txtCurrentPswd: TextFieldLeftImage!
    @IBOutlet weak var lblConfirmPswdAlert: UILabel!
    @IBOutlet weak var txtConfirmPswd: TextFieldLeftImage!
    @IBOutlet weak var lblConfirmPswdTitle: UILabel!
    @IBOutlet weak var lblNewPswdAlert: UILabel!
    @IBOutlet weak var txtNewPswd: TextFieldLeftImage!
    @IBOutlet weak var lblNewPswdTitle: UILabel!
    /// Validator initialize
    var validator = Validator()
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

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
        validator.registerField(txtCurrentPswd, errorLabel: lblCurrentPswdAlert, rules: [RequiredRule(message: "PasswordError".localized)])
        validator.registerField(txtNewPswd, errorLabel: lblNewPswdAlert, rules: [RequiredRule(message: "PasswordError".localized)])
        validator.registerField(txtConfirmPswd, errorLabel: lblConfirmPswdAlert, rules: [RequiredRule(message: "PasswordError".localized)])

    }

    // MARK: ValidationDelegate methods

    /**
     Validation successfully checked delegate method
     */
    func validationSuccessful() {
        if (lblNewPswdAlert.text?.isEmpty)! && (lblConfirmPswdAlert.text?.isEmpty)! && (lblConfirmPswdAlert.text?.isEmpty)! {
            print("Done")
//            userObj?.password = txtPswd.text
//            self.performSegue(withIdentifier: StoryboardSegue.Main.showMemberInfo.rawValue, sender: self)
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
            if (txtNewPswd.text?.isEmpty)! {  txtNewPswd.setBorder(with: #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1529411765, alpha: 1))}
            if (txtConfirmPswd.text?.isEmpty)! {  txtConfirmPswd.setBorder(with: #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1529411765, alpha: 1))}
        }
    }

    @IBAction func btnUpdateTapped(_ sender: Any) {
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
