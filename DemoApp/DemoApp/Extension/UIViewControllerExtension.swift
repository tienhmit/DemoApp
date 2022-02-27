//
//  UIViewControllerExtension.swift
//  WindyDemo2
//
//  Created by Đào Mỹ Đông on 25/02/2022.
//

import Foundation
import UIKit

extension UIViewController {

    class func initWithDefaultNib() -> Self {
        let bundle = Bundle(for: self)
        let fileManege = FileManager.default
        let nibName = String(describing: self)
        
        if let pathStoryboard = bundle.path(forResource: nibName, ofType: "storyboardc") {
            if fileManege.fileExists(atPath: pathStoryboard) {
                return initWithDefautlStoryboard()
            }
        }
        
        if let pathXib = bundle.path(forResource: nibName, ofType: "nib") {
            if fileManege.fileExists(atPath: pathXib) {
                return initWithNibTemplate()
            }
        }
        return initWithNibTemplate()
    }
    
    private class func initWithNibTemplate<T>() -> T {
        let nibName = String(describing: self)
        let bunder = Bundle(for: self)
        let viewcontroller = self.init(nibName: nibName, bundle: bunder)
        return viewcontroller as! T
    }
    
    class func initWithDefautlStoryboard() -> Self {
        let className = String(describing: self)
        return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: className)
    }
    
    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
}
