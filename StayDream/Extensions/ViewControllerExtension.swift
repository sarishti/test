//
//  ViewControllerExtension.swift

import Foundation
import UIKit
extension UIViewController {

    func popViewController(animated: Bool) {
        _ = self.navigationController?.popViewController(animated: animated)
    }

    func setNavBarHide(hide: Bool) {
        self.navigationController?.isNavigationBarHidden = hide
    }
    func setNavBarBackHide(hide: Bool) {
        self.navigationItem.setHidesBackButton(hide, animated: false)
    }

    func removeChildViewController() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    /// To set the color of text fields after validation
    ///
    /// - parameter textField:    textfield which contain data
    /// - parameter lblTitle:     label whicxh shows above title
    /// - parameter lblAlert:     label shows red alert text
    /// - parameter imgUnderLine: underline with red line/green
    /// - parameter imgTitle:     left side image of text field
    /// - parameter error:        error message from localize

    func validateFields(textField: UITextField, lblAlert: UILabel?, error: String) {
        if (textField.text?.length)! <= 0 {
            lblAlert?.text = ""
             lblAlert?.isHidden = true
            textField.setBorder(with: #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1))
        } else {
            lblAlert?.isHidden = false
            lblAlert?.text = error
            let color = error.isEmpty ? #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1) : #colorLiteral(red: 0.8470588235, green: 0, blue: 0.1529411765, alpha: 1)
             textField.setBorder(with: color)
        }
    }
    // MARK : Navigation bar helper methods
    /// Chaneg navigation bar light
    func changeNavBarAppearanceLight(color: UIColor = #colorLiteral(red: 0.5699723363, green: 0.1442027688, blue: 0.6577451825, alpha: 1)) {
        // Change the color of the navigation and status bar
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBarAppearace.barTintColor = color
        navigationBarAppearace.backgroundColor = color
        if let font = FontFamily.Tahoma.bold.font(size: 15) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        }
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    /// Change navigation bar dark color with blue
    func changeNavBarAppearanceDark() {
        // Change the color of the navigation and status bar
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = #colorLiteral(red: 0.5699723363, green: 0.1442027688, blue: 0.6577451825, alpha: 1)
        navigationBarAppearace.barTintColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBarAppearace.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if let font = FontFamily.Tahoma.bold.font(size: 15) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.1568627451, green: 0.1921568627, blue: 0.3058823529, alpha: 1)]
        }
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

}
