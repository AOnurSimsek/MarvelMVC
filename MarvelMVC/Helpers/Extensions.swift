//
//  Extensions.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 16.02.2022.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension Optional where Wrapped == String {
     func unwrapError() -> String {
        if let str = self {
            return str
        }
        else {
            return "An unexpected error occured."
        }
    }
    
    func unwrapString() -> String{
        if let str = self {
            if str == "" {
                return "Data not found"
            }
            return str
        }
        else {
            return "Data not found"
        }
    }
    
    func getImageUrl(format: String?) -> String {
        if let base = self, let ext = format {
            return base+"."+ext
        }
        else {
            return ""
        }
    }
}

extension String {
    
    func createAttributedText(stringTwo:String) -> NSMutableAttributedString {
        if stringTwo == "" {
            let emptyAttributedString = NSMutableAttributedString(string: "-")
            return emptyAttributedString
        }
        else {
            let firstAttributedString = NSMutableAttributedString(string: self)
            firstAttributedString.addAttribute(.foregroundColor, value: UIColor.marvelLogoRed, range:NSRange(location: 0, length: self.count))
            firstAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24, weight: .medium), range: NSRange(location: 0, length: self.count))
            let secondAttributedString = NSMutableAttributedString(string: stringTwo)
            secondAttributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range:NSRange(location: 0, length: stringTwo.count))
            secondAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: NSRange(location: 0, length: stringTwo.count))
            firstAttributedString.append(secondAttributedString)
            return firstAttributedString
        }
    }
    
    func md5() -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        return String(format: hash as String)
    }
}

extension UIViewController {
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func makeShadow(color: UIColor, offset: CGSize, opacity: Float, radius: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.clipsToBounds = false
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    @nonobjc class var marvelLogoRed : UIColor {
        return UIColor.init(hexString: "ED1D24")
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

