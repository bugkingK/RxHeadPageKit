//
//  RxHeadPageDataSourceProxy.swift
//  
//
//  Created by Bugking on 2020/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import HeadPageKit

final class RxHeadPageDataSourceProxy: DelegateProxy<HeadPageViewController, HeadPageControllerDataSource> {
    
    init(headPageViewController: HeadPageViewController) {
        super.init(parentObject: headPageViewController, delegateProxy: RxHeadPageDataSourceProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxHeadPageDataSourceProxy(headPageViewController: $0) }
    }
    
    static func currentDelegate(for object: HeadPageViewController) -> HeadPageControllerDataSource? {
        return object.dataSource
    }
    
    static func setCurrentDelegate(_ delegate: HeadPageControllerDataSource?, to object: HeadPageViewController) {
        object.dataSource = delegate
    }
}

extension RxHeadPageDataSourceProxy: DelegateProxyType { }

extension RxHeadPageDataSourceProxy: HeadPageControllerDataSource {
    func headerViewFor(_ pageController: HeadPageViewController) -> UIView? {
        return forwardToDelegate()?.headerViewFor(pageController)
    }
    
    func headerViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return forwardToDelegate()?.headerViewHeightFor(pageController)
    }
    
    func menuViewFor(_ pageController: HeadPageViewController) -> UIView? {
        return forwardToDelegate()?.menuViewFor(pageController)
    }
    
    func menuViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return forwardToDelegate()?.menuViewHeightFor(pageController)
    }
    
    func numberOfViewControllers(in pageController: HeadPageViewController) -> Int {
        return forwardToDelegate()?.numberOfViewControllers(in: pageController) ?? 0
    }
    
    func pageController(_ pageController: HeadPageViewController, viewControllerAt index: Int) -> (UIViewController & HeadPageChildViewController) {
        return forwardToDelegate()!.pageController(pageController, viewControllerAt: index)
    }
    
}
