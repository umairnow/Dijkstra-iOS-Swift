//
//  Extensions.swift
//  InterviewTest
//
//  Created by Umair Aamir on 2/4/16.
//  Copyright © 2016 MyWorkout AS. All rights reserved.
//

import UIKit

extension UIView {
    
    public static func loadFromNib () -> UIView? {
        let nibName = self.nameOfClass
        let elements = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil)
        for anObject in elements {
            if anObject.isKindOfClass(self) {
                return anObject as? UIView
            }
        }
        return nil
    }
    
    public class func instantiateFromNib<T: UIView>(viewType: T.Type) -> T {
        return NSBundle.mainBundle().loadNibNamed(String(viewType), owner: nil, options: nil).first as! T
    }
    
    public class func instantiateFromNib() -> Self {
        return instantiateFromNib(self)
    }
    
}

public extension NSObject{
    public class var nameOfClass: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    public var nameOfClass: String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}

extension String {
    
    var asciiValue: UInt32 {
        let lowerCase = self.lowercaseString
        if lowerCase.isEmpty {
            return 0
        }
        return lowerCase.characters.first!.unicodeScalarsValue
    }
    
    internal func trimEndsSpacing() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

extension Character {
    var unicodeScalarsValue: UInt32 {
        return String(self).unicodeScalars.first!.value
    }
}

extension Array {
    func splitBy(subSize: Int) -> [[Element]] {
        return 0.stride(to: self.count, by: subSize).map { startIndex in
            let endIndex = startIndex.advancedBy(subSize, limit: self.count)
            return Array(self[startIndex ..< endIndex])
        }
    }
}


extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}
