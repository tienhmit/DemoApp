//
//  UIScrollViewExtension.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation
import UIKit

fileprivate var kUIScrollViewPullToRefreshViewCustom = "kUIScrollViewPullToRefreshViewCustom"
typealias UISsrollViewActionHandleBlock = () -> Void

protocol PropertyStoring {
    associatedtype T
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T
}

extension PropertyStoring {
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
}

fileprivate class TUIRefreshControl: UIRefreshControl {
    
    var handler: UISsrollViewActionHandleBlock?
    
    override init() {
        super.init()
        self.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        
        DispatchQueue.main.async { [weak self] in
            self?.tintColor = UIColor.gray
        }
        
        self.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        DispatchQueue.main.async { [weak self] in
            self?.tintColor = UIColor.gray
        }
        
        self.endRefreshing()
    }
    
    @objc fileprivate func doRefresh() {
        handler?()
    }
    
    deinit {
        handler = nil
    }
}

extension UIScrollView {
    
    private var kRefreshControl: TUIRefreshControl? {
        set {
            objc_setAssociatedObject(self,
                                     &kUIScrollViewPullToRefreshViewCustom,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            if let view = (objc_getAssociatedObject(self, &kUIScrollViewPullToRefreshViewCustom) as? TUIRefreshControl) {
                return view
            }
            return nil
        }
    }
    
    var isPullToRefreshing: Bool {
        return kRefreshControl?.isRefreshing ??  false
    }
    
    func kAddPullToRefreshCustom(_ handle: @escaping UISsrollViewActionHandleBlock) {
        if kRefreshControl != nil {
            kRefreshControl?.handler = handle
            return
        }
        
        let indicator = TUIRefreshControl()
        indicator.handler = handle
        self.addSubview(indicator)
        kRefreshControl = indicator
    }
    
    func kAddInfiniteScrolling(_ handle: @escaping UISsrollViewActionHandleBlock) {
        
    }
    
    func kRemovePullToRefresh() {
        kRefreshControl?.removeFromSuperview()
        kRefreshControl = nil
    }
    
    func kPullToRefreshStartAnimation() {
        guard let view = kRefreshControl else {
            return
        }
        
        if view.isRefreshing {
            return
        }
        
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.kRefreshControl?.beginRefreshing()
        }
    }
    
    func kPullToRefreshStopAnimation() {
        guard let view = kRefreshControl else {
            return
        }
        
        if !view.isRefreshing {
            return
        }
        
        CATransaction.begin()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.kRefreshControl?.endRefreshing()
        }
        CATransaction.commit()
    }
}
