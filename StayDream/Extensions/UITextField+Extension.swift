//
//  UITextField+Extension.swift

import Foundation
import UIKit
// text field extension 
extension UITextField {

	// To check text field blank
	var isBlank: Bool {
		get {
			guard let textStr = text, textStr.isBlank == false else {

				return true
			}
			return textStr.isBlank
		}
	}

    /// Returns the text of field
	var textTyped: String {
		get {
			guard let textStr = text, textStr.isBlank == false else {
				return ""
			}
			return textStr
		}
	}
}
