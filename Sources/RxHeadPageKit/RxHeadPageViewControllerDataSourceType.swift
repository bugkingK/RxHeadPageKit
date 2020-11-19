//
//  RxHeadPageViewControllerDataSourceType.swift
//  
//
//  Created by Bugking on 2020/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import HeadPageKit

public typealias HeadPageViewControllerType = UIViewController & HeadPageChildViewController

public protocol RxHeadPageViewControllerDataSourceType {
    
    associatedtype Element
    
    func pageController(_ pageController: HeadPageViewController, observedEvent: Event<Element>)
}

public struct RxHeadPageConfigurationModel {
    let headerView: UIView
    let headerHeight: CGFloat
    let menuView: UIView
    let menuHeight: CGFloat
    let viewControllers: [HeadPageViewControllerType]
    
    public init(headerView: UIView,
                headerHeight: CGFloat,
                menuView: UIView,
                menuHeight: CGFloat,
                viewControllers: [HeadPageViewControllerType]) {
        self.headerView = headerView
        self.headerHeight = headerHeight
        self.menuView = menuView
        self.menuHeight = menuHeight
        self.viewControllers = viewControllers
    }
}

public class RxHeadPageViewControllerReactiveArrayDataSource {
    
    public typealias Element = RxHeadPageConfigurationModel
    
    public typealias VCFactory = (Int, HeadPageViewControllerType) -> HeadPageViewControllerType
    
    var model: RxHeadPageConfigurationModel?
    
    public func modelAtIndex(_ index: Int) -> HeadPageViewControllerType? {
        return model?.viewControllers[index]
    }
    
    public func model(at indexPath: IndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = model?.viewControllers[indexPath.item] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        
        return item
    }
    
    let vcFactory: VCFactory
    
    public init(vcFactory: @escaping VCFactory) {
        self.vcFactory = vcFactory
    }
    
}

extension RxHeadPageViewControllerReactiveArrayDataSource: RxHeadPageViewControllerDataSourceType {
    
    public func pageController(_ pageController: HeadPageViewController, observedEvent: Event<Element>) {
        Binder(self) { dataSource, elements in
            dataSource.model = elements
            pageController.reloadData()
        }.on(observedEvent)
    }
    
}

extension RxHeadPageViewControllerReactiveArrayDataSource: HeadPageControllerDataSource {
    public func headerViewFor(_ pageController: HeadPageViewController) -> UIView? {
        return model?.headerView
    }
    
    public func headerViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return model?.headerHeight
    }
    
    public func menuViewFor(_ pageController: HeadPageViewController) -> UIView? {
        return model?.menuView
    }
    
    public func menuViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return model?.menuHeight
    }
    
    public func numberOfViewControllers(in pageController: HeadPageViewController) -> Int {
        return model?.viewControllers.count ?? 0
    }
    
    public func pageController(_ pageController: HeadPageViewController, viewControllerAt index: Int) -> (UIViewController & HeadPageChildViewController) {
        return vcFactory(index, model!.viewControllers[index])
    }
    
}
