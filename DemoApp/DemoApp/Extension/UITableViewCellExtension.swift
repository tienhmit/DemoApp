//
//  UITableViewCellExtension.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class func dequeCellWithTable(_ table: UITableView) -> Self {
        let nibName = String(describing: self)
        if table.dequeueReusableCell(withIdentifier: nibName) == nil {
            let nib = UINib(nibName: nibName, bundle: nil)
            table.register(nib, forCellReuseIdentifier: nibName)
        }
        
        return initWithNibTemplate(table)
    }
    
    class func dequeCellWithNibName(_ table: UITableView, nibName: String) -> Self {
        if table.dequeueReusableCell(withIdentifier: nibName) == nil {
            let nib = UINib(nibName: nibName, bundle: nil)
            table.register(nib, forCellReuseIdentifier: nibName)
        }
        
        return initWithNibTemplate(table, nibName)
    }
    
    class func dequeCellWithTable(_ table: UITableView, _ identifier: String) -> Self {
        let nibName = String(describing: self)
        if table.dequeueReusableCell(withIdentifier: nibName) == nil {
            let nib = UINib(nibName: nibName, bundle: nil)
            table.register(nib, forCellReuseIdentifier: identifier)
        }
        
        return initWithNibTemplate(table, identifier)
    }
    
    private class func initWithNibTemplate<T>(_ table: UITableView) -> T {
        let nibName = String(describing: self)
        let cell = table.dequeueReusableCell(withIdentifier: nibName)
        return cell as! T
    }
    
    private class func initWithNibTemplate<T>(_ table: UITableView, _ identifier: String) -> T {
        let cell = table.dequeueReusableCell(withIdentifier: identifier)
        return cell as! T
    }
}
