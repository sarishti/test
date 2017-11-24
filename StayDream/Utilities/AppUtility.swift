// AppUtility.swift

import Foundation
import UIKit
import AVFoundation
import CoreTelephony
import MBProgressHUD

struct AppUtility {
    static let keyDeviceId = "DeviceIdentifier"
    enum ObjectType: Int { case NumberType = 0, StringType = 1 }
    /**
     Get the reference of AppDelegate
     
     - returns: AppDelegate
     */
    static func appDelegate () -> AppDelegate? {
        if let appDelegateValue = UIApplication.shared.delegate as? AppDelegate {
            return appDelegateValue
        } else {
            return nil
        }
    }
    // MARK: - Check Password validation
    static func validatePassword(passwordStr: String) -> Bool {
        let passwordRegex: String = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
        let predicateForPswd: NSPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicateForPswd.evaluate(with: passwordStr)
    }

    // MARK: - Get value from dictionary

    static func getObjectForKey(_ key: String!, dictResponse: NSDictionary!) -> AnyObject! {
        if key != nil {
            if let dict = dictResponse {
                if let value: AnyObject = dict.value(forKey: key) as AnyObject? {
                    return value
                } else {
                    return nil
                }

            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    // MARK: - Show AlertView

    static func showAlert(_ title: String, message: String, delegate: AnyObject?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OkTitle".localized, style: .cancel) { (action) in
            print(action)
        }
        alertController.addAction(okAction)

        AppUtility.appDelegate()?.window?.rootViewController?.present(alertController,
                                                                      animated: true,
                                                                      completion: {

        })

    }

    // MARK: - Get value from user defaults
    static func getValueFromUserDefaultsForKey(_ keyName: String!) -> AnyObject? {
        if keyName.isBlank {
            return nil
        }
        if let value = UserDefaults.standard.object(forKey: keyName) {
            return value as AnyObject
        }

        return nil
    }

    // MARK: - Set value to user defaults

    static func setValueToUserDefaultsForKey(_ keyName: String!, value: AnyObject!) {

        if keyName.isBlank {
            return
        }
        if value == nil {
            return
        }
        UserDefaults.standard.setValue(value, forKey: keyName)
        UserDefaults.standard.synchronize()
    }
    // MARK: Remove key chain

    static func removeKeyChainValues() {
        guard let _ = AppUtility.getValueFromUserDefaultsForKey(AppConstants.isAppUninstallKey) else {
            self.removeKeyChain()
            AppUtility.setValueToUserDefaultsForKey(AppConstants.isAppUninstallKey, value: true as AnyObject!)
            return
        }
    }

    // MARK: Remove keyChain
    static func removeKeyChain() {
        KeychainWrapper.standard.removeObject(forKey: AppConstants.appTokenKeyChain)
        KeychainWrapper.standard.removeObject(forKey: AppConstants.userTokenKeyChain)
        //languageDefaultKey
    }
    /// Remove keys from user default
    static func removeUserDefaultKeys() {
        // remove token on logout
         KeychainWrapper.standard.removeObject(forKey: AppConstants.userTokenKeyChain)
    }

    /// On logout set app token rather than user token
    static func setAppToken() {
        if let tokenObj = KeychainWrapper.standard.object(forKey: AppConstants.appTokenKeyChain) {
            if let appTokenObj = tokenObj as? AccessToken, let token = appTokenObj.accessToken {
                Configuration.customHeaders["Authorization"] = "Bearer \(token)"
            }
        }
    }

    // MARK: - remove value from user defaults
    static func removeValueFromUserDefaultsForKey(_ keyName: String!) {

        if keyName.isBlank {
            return
        }

        UserDefaults.standard.removeObject(forKey: keyName)
        UserDefaults.standard.synchronize()
    }

    // Used to fetch the controller via StoryBoard
    static func fetchViewControllerWithName(_ vcName: String, storyBoardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let controller: UIViewController = storyboard.instantiateViewController(withIdentifier: vcName)
        return controller
    }

    static func classWithString(_ str: String) -> AnyClass {
        return NSClassFromString(str)!
    }

    // MARK: Date time calculation
    static func calculateDateTime(_ dateStr: String) -> Date {
        // Convert string to date object
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormat.date(from: dateStr)
        return date!

    }

    static func printFontFamilyName() {
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }

    }
    // MARK: - Check Email validation
    static func validateEmail(emailStr: String) -> Bool {
        let trimmedString =  trimSpace(str:emailStr)
        let emailRegex: String = "^[_\\p{L}\\p{Mark}0-9-]+(\\.[_\\p{L}\\p{Mark}0-9-]+)*@[\\p{L}\\p{Mark}0-9-]+(\\.[\\p{L}\\p{Mark}0-9]+)*(\\.[\\p{L}\\p{Mark}]{2,})$"
        let predicateForEmail: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicateForEmail.evaluate(with: trimmedString)
    }
    static func trimSpace(str: String) -> String {
        return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /**
     This method is used add basic constaraints ie top, bottom, leading and trailing to subView
     
     - parameter subView:   UIView
     - parameter superView: UIView
     */
    static func addBasicConstraintsOnSubView(_ subView: UIView, onSuperView superView: UIView) {

        subView.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                options: NSLayoutFormatOptions.alignmentMask, metrics: nil,
                                                                views: NSDictionary(object: subView, forKey: "subView" as NSCopying) as? [String: AnyObject] ?? [:]))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[subView]|",
                                                                options: NSLayoutFormatOptions.alignmentMask,
                                                                metrics: nil,
                                                                views: NSDictionary(object: subView,
                                                                                    forKey: "subView" as NSCopying) as? [String: AnyObject] ?? [:]))
    }

    /**
     This method is used to convert a json string to dictionary
     
     - parameter text: String
     
     - returns: [String: AnyObject]
     */
    static func convertStringToDictionary(_ text: String) -> [String: AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch let error as NSError {
                print(error)
            } catch {
                // Catch any other errors
            }
        }
        return nil
    }

    /**
     Check if device supprts phone call
     
     - returns: Bool
     */
    static func canMakeACall() -> Bool {
        var canMakeACall = false
        if UIApplication.shared.canOpenURL(URL.init(string: "tel://")!) {
            // Check if iOS Device supports phone calls
            let networkInfo = CTTelephonyNetworkInfo()
            let carrier = networkInfo.subscriberCellularProvider
            if carrier == nil {
                return false
            }
            let mnc = carrier?.mobileNetworkCode
            if mnc?.length == 0 {
                // Device cannot place a call at this time.  SIM might be removed.
            } else {
                // iOS Device is capable for making calls
                canMakeACall = true
            }
        } else {
            // iOS Device is not capable for making calls
        }
        return canMakeACall
    }

    /**
     Update applicationIconBadgeNumber
     
     - parameter factor: Int (-/+)
     */
    static func updateApplicationIconBadgeNumberBy(_ factor: Int) {
        let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        if factor < 0 {
            if badgeNumber > 0 {
                UIApplication.shared.applicationIconBadgeNumber = badgeNumber + factor
            }
        } else if badgeNumber > 0 {
            UIApplication.shared.applicationIconBadgeNumber = badgeNumber + factor
        } else {
            UIApplication.shared.applicationIconBadgeNumber = factor
        }
    }

    /**
     Resize the image to new size
     
     - parameter image:  UIImage
     - parameter toSize: CGSize
     
     - returns: UIImage
     */
    static func resizeImage(_ image: UIImage, toSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(toSize)
        image.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    static func showLoader(isOffSet: Bool = false) {
        DispatchQueue.main.async {
            guard let window = AppUtility.appDelegate()?.window else { return }
            let loader = MBProgressHUD.showAdded(to: window, animated: true)
            loader.mode = MBProgressHUDMode.customView
            loader.margin = 0.0
            loader.bezelView.backgroundColor = UIColor.clear
            loader.bezelView.color = UIColor.clear
            loader.bezelView.style = .solidColor
            let imgViewGif = UIImageView()
            imgViewGif.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
            if let gifUrl = Bundle.main.url(forResource: "image_loader", withExtension:"gif") {
                imgViewGif.image = UIImage.animatedImage(withAnimatedGIFURL: gifUrl)
            }
            if isOffSet {
                loader.offset.y =  (AppUtility.appDelegate()?.window?.frame.size.height)! - 200 // so that loader come on bottom
            } else {
                loader.center = window.center
            }
            imgViewGif.clipsToBounds = true
            loader.customView = imgViewGif
        }
    }
    static func dismissLoaderOnView() {
        guard let window = AppUtility.appDelegate()?.window else { return }
        MBProgressHUD.hide(for: window, animated: true)

    }
    /// Get labngiuage code
    ///
    /// - Parameter language: value of language
    /// - Returns: return key is code in string "en" "fr" etc
    static func getLanguageCode(language: Int) -> String {
        switch language {
        case 0:
            return Enums.LanguageCode.english.rawValue
        case 1:
            return Enums.LanguageCode.franch.rawValue
        case 2:
            return Enums.LanguageCode.spanish.rawValue
        case 3:
            return Enums.LanguageCode.chines.rawValue
        default:
            return Enums.LanguageCode.english.rawValue
        }
    }
    // Eye and button button on right side of text field
    static func getRightButton(with image: UIImage) -> UIButton {
        let btnColor = UIButton(type: .custom)
        btnColor.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(25))
        btnColor.setImage(image, for: .normal)
        return btnColor
    }
    static func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

}
