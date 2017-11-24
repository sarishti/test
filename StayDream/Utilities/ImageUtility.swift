//
//  ImageUtility.swift
//  DITY
//

import Foundation
struct ImageUtility {

    /// get the s3 image extension to save depening upon our image extension
    ///
    /// - parameter fileName: file name
    ///
    /// - returns: extension name in string
    static func getS3ImageExtension(_ fileName: String) -> String {
        var contentType = ""
        let fileNameArr = fileName.components(separatedBy: ".")
        if fileNameArr.count >= 2 {
            switch fileNameArr[1].lowercased() {
            case "mp4":
                contentType = "movie/mp4"
            case "jpg":
                contentType = "image/jpg"
            case "jpeg":
                contentType = "image/jpeg"
            case "png":
                contentType = "image/png"
            case "mp3":
                contentType = "audio/mpeg"
            default:
                contentType = "txt"
            }
        }
        return contentType
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

    /// Save the image on temp with particular name
    ///
    /// - parameter image:    image which want to save
    /// - parameter fileName: file name of image
    /// - parameter isThumb:  if same name and we want to add thumb then add _thumb after image name
    static func saveImageToTemp(_ image: UIImage, withName fileName: String, isThumb: Bool = false) {
        let fileNameArr = fileName.components(separatedBy: ".")
        if fileNameArr.count < 2 {
            return
        }
        let name = isThumb ? fileNameArr[0].lowercased() + "_thumb" : fileNameArr[0].lowercased()
        let extensionValue = fileNameArr[1].lowercased()
        var data = UIImageJPEGRepresentation(image, 1.0)
        if extensionValue == "jpeg" || extensionValue == "jpg"{
            data = UIImageJPEGRepresentation(image, 1.0)
        } else if extensionValue == "png"{
            data = UIImagePNGRepresentation(image)
        } else {
            AppUtility.showAlert( "", message: "sorry invalid format", delegate: nil)
        }
        let tmpDirURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        let fullPath = tmpDirURL.appendingPathComponent(name).appendingPathExtension(extensionValue)
//        DLog(message:"FilePath: \(fullPath.path)")
        do {
            try data?.write(to: fullPath, options: .atomic)
        } catch {
//            DLog(message:"ERrror\(error)")
        }
    }

    /// Remove temp files
    static func removetemp() {
        do {
            let tmpDirectory = try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
            for file: String in tmpDirectory {
                do {
                    try FileManager.default.removeItem(atPath: "\(NSTemporaryDirectory())\(file)")
                } catch {
//                    DLog(message:"Didn't delete")
                }
            }
        } catch {
//            DLog(message:"Error\(error)")
        }
    }

    /// get images from temp
    ///
    /// - parameter name: name of image
    ///
    /// - returns: return ui image from temp
    static func loadImageFromTemp(_ name: String) -> UIImage {
        let fullPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name).absoluteString
        let img = UIImage(contentsOfFile: fullPath)!
        return img
    }
}
