//
//  File.swift
//  
//
//  Created by Bugking on 2020/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import HeadPageKit

final class RxHeadPageDelegateProxy: DelegateProxy<HeadPageViewController, HeadPageViewControllerDelegate> {
    
    let willCache: PublishSubject<Int> = .init()
    let willDisplay: PublishSubject<Int> = .init()
    let didDisplay: PublishSubject<Int> = .init()
    let isAdsorption: PublishSubject<Bool> = .init()
    let didContentScroll: PublishSubject<UIScrollView> = .init()
    
    init(headPageViewController: HeadPageViewController) {
        super.init(parentObject: headPageViewController, delegateProxy: RxHeadPageDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxHeadPageDelegateProxy(headPageViewController: $0) }
    }
    
    static func currentDelegate(for object: HeadPageViewController) -> HeadPageViewControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: HeadPageViewControllerDelegate?, to object: HeadPageViewController) {
        object.delegate = delegate
    }
}

extension RxHeadPageDelegateProxy: DelegateProxyType { }

extension RxHeadPageDelegateProxy: HeadPageViewControllerDelegate {
    
    func pageController(_ pageController: HeadPageViewController, willCache viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) {
        willCache.onNext(index)
    }
    
    func pageController(_ pageController: HeadPageViewController, willDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) {
        willDisplay.onNext(index)
    }
    
    func pageController(_ pageController: HeadPageViewController, didDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) {
        didDisplay.onNext(index)
    }
    
    func pageController(_ pageController: HeadPageViewController, menuView isAdsorption: Bool) {
        self.isAdsorption.onNext(isAdsorption)
    }
    
    func pageController(_ pageController: HeadPageViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        didContentScroll.onNext(scrollView)
    }
}
