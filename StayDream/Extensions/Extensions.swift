//
//  Extensions.swift
//  VLT
//
//  Created by Sharisti on 04/09/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
import UIKit
// Array Extension
extension Array {
    /// Check  array consist particular index
    ///
    /// - parameter index: index value
    ///
    /// - returns: true/false
    func isIndexWithinBound(index: Int) -> Bool {
        if index >= 0 && self.count > index {
            return true
        }

        return false
    }
}
extension UITableView {

    // MARK: - Table Height find fucntion

    /// Preferred height of table view
    ///
    /// - returns: size of table view
    func preferredContentSizeOfTable() -> CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
}
extension UIButton {

    func setBorder(with color: UIColor) {
        self.layer.borderColor = color.cgColor
    }

}
extension UITextField {

    func setBorder(with color: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)

        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }

}
// MARK: - Hex, Hex + Alpha, RGB, RGB + Alpha

extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }

    convenience init(hex: Int, alpha: CGFloat) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff, alpha: alpha)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    convenience init?(hexString: String) {
        guard let hex = hexString.hex else {
            return nil
        }
        self.init(hex: hex)
    }
}

extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}
extension NSMutableArray {
    /// Check mutable array consist particular index
    ///
    /// - parameter index: index value
    ///
    /// - returns: true/false
    func isIndexWithinBound(index: Int) -> Bool {
        if index >= 0 && self.count > index {
            return true
        }

        return false
    }
}

extension UIImage {

    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}
