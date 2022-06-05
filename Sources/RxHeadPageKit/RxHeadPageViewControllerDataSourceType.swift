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

public struct HeadPageConfigModel {
    let originIndex: Int
    let sourceView: UIView?
    let headerView: UIView?
    let headerHeight: CGFloat?
    let menuView: (UIView & MenuViewProtocol)?
    let menuTitles: [String]
    let menuViewHeight: CGFloat
    let menuViewPinHeight: CGFloat
    let contentInset: UIEdgeInsets
    let viewControllers: [HeadPageViewControllerType]
    
    public init(originIndex: Int = 0,
                sourceView: UIView? = nil,
                headerView: UIView? = nil,
                headerHeight: CGFloat? = nil,
                menuView: (UIView & MenuViewProtocol)?,
                menuTitles: [String],
                menuHeight: CGFloat,
                menuViewPinHeight: CGFloat = 0,
                contentInset: UIEdgeInsets = .zero,
                viewControllers: [HeadPageViewControllerType]) {
        self.originIndex = originIndex
        self.sourceView = sourceView
        self.headerView = headerView
        self.headerHeight = headerHeight
        self.menuView = menuView
        self.menuTitles = menuTitles
        self.menuViewHeight = menuHeight
        self.menuViewPinHeight = menuViewPinHeight
        self.contentInset = contentInset
        self.viewControllers = viewControllers
    }
}

public class RxHeadPageViewControllerReactiveArrayDataSource {
    
    public typealias Element = HeadPageConfigModel
    
    public typealias VCFactory = (Int, HeadPageViewControllerType) -> HeadPageViewControllerType
    
    var model: HeadPageConfigModel?
    
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

extension RxHeadPageViewControllerReactiveArrayDataSource: HeadPageViewControllerDataSource {
    public func sourceViewFor(_ pageController: HeadPageViewController) -> UIView? {
        return model?.sourceView
    }
    
    public func numberOfViewControllers(in pageController: HeadPageViewController) -> Int {
        return model?.viewControllers.count ?? 0
    }
    
    public func pageController(_ pageController: HeadPageViewController, viewControllerAt index: Int) -> (UIViewController & HeadPageChildViewController) {
        return vcFactory(index, model!.viewControllers[index])
    }
    
    public func headerViewFor(_ pageController: HeadPageViewController) -> UIView? {
        return model?.headerView
    }
    
    public func headerViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return model?.headerHeight
    }
    
    public func menuViewFor(_ pageController: HeadPageViewController) -> (UIView & MenuViewProtocol)? {
        return model?.menuView
    }
    
    public func menuViewTitleFor(_ pageController: HeadPageViewController) -> [String] {
        return model?.menuTitles ?? []
    }
    
    public func menuViewHeightFor(_ pageController: HeadPageViewController) -> CGFloat? {
        return model?.menuViewHeight
    }
    
    public func menuViewPinHeightFor(_ pageController: HeadPageViewController) -> CGFloat {
        return model?.menuViewPinHeight ?? 0
    }

    public func originIndexFor(_ pageController: HeadPageViewController) -> Int {
        return model?.originIndex ?? 0
    }
    
    public func contentInsetFor(_ pageController: HeadPageViewController) -> UIEdgeInsets {
        return model?.contentInset ?? .zero
    }
}
