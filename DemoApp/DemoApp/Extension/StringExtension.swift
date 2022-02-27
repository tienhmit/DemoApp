//
//  StringExtension.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

extension String {
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var removeVietnamese: String {
        var value = self.folding(options: .diacriticInsensitive, locale: .current)
        value = value.replacingOccurrences(of: "Đ", with: "D")
        value = value.replacingOccurrences(of: "đ", with: "d")
        return value
    }
    
    func isValidURL() -> Bool {
        guard !contains("..") else{return false}
        let head        = "((http|https)://)?([(w|W)]{3}+\\.)?"
        let tail        = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlRegEx    = head+"+(.)+"+tail
        let urlTest     = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: trimmingCharacters(in: .whitespaces))
    }
    
    static func attributedText(_ string1: String) -> NSAttributedString? {
        return NSAttributedString.init(string: string1)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
    
    func size(withConstrainedWidth width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        var size = boundingBox.size
        size.width = size.width < 40.0 ? 40.0 : size.width
        size.width += 2.0
        size.height += 2.0
        return size
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return ceil(boundingBox.width)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    static func displayMoneyFormat(_ number: Double?)-> String {
        guard let value = number else {
            return "0"
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.groupingSize = 3
        currencyFormatter.decimalSeparator = "."
        
        if let priceString = currencyFormatter.string(from: NSNumber(value: value)) {
            return priceString
        }
        return "0"
    }

    func firstCharactor()-> String {
        if self.count > 0 {
            return String(self.prefix(1))
        }
        return ""
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var searchString: String {
        return self.removeVietnamese.replacingOccurrences(of: " ", with: "").lowercased()
    }
}
