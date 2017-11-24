//
//  TextFieldLeftImage.swift
//  StayDream
//
//  Created by Sharisti on 24/10/17.
//  Copyright © 2017 Netsolutions. All rights reserved.
//

import Foundation
import UIKit

class TextFieldLeftImage: UITextField {

    // Provides right padding for images
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.textRect(forBounds: bounds)
        rect.origin.x = rect.origin.x + rightPadding
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.editingRect(forBounds: bounds)
        rect.origin.x = rect.origin.x + rightPadding
        rect.size.width = rect.size.width - 10
        return rect
    }

    // provide left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    // provide right padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x = textRect.origin.x - 10
        return textRect
    }
    // get the image and border color

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return self.borderColor
        }
        set {
            self.borderStyle = UITextBorderStyle.none
            let border = CALayer()
            let width = CGFloat(0.5)
            border.borderColor = newValue?.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)

            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true

        }
    }
    // get the left padding and right padding value
    @IBInspectable var leftPadding: CGFloat = 0
      @IBInspectable var rightPadding: CGFloat = 0

    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    // update the view
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }

        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
}
