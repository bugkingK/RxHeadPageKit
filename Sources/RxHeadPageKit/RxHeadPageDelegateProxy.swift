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

final class RxHeadPageDelegateProxy: DelegateProxy<HeadPageViewController, HeadPageControllerDelegate> {
    
    let (willCacheSubject, willCache): (PublishSubject<Int>, ControlEvent<Int>) = {
        let subject = PublishSubject<Int>()
        return (subject, ControlEvent<Int>(events: subject.asObserver()))
    }()
    
    let (willDisplaySubject, willDisplay): (PublishSubject<Int>, ControlEvent<Int>) = {
        let subject = PublishSubject<Int>()
        return (subject, ControlEvent<Int>(events: subject.asObserver()))
    }()
    
    let (didDisplaySubject, didDisplay): (PublishSubject<Int>, ControlEvent<Int>) = {
        let subject = PublishSubject<Int>()
        return (subject, ControlEvent<Int>(events: subject.asObserver()))
    }()
    
    let (isAdsorptionSubject, isAdsorption): (PublishSubject<Bool>, ControlEvent<Bool>) = {
        let subject = PublishSubject<Bool>()
        return (subject, ControlEvent<Bool>(events: subject.asObserver()))
    }()
    
    let (didContentScrollSubject, didContentScroll): (PublishSubject<UIScrollView>, ControlEvent<UIScrollView>) = {
        let subject = PublishSubject<UIScrollView>()
        return (subject, ControlEvent<UIScrollView>(events: subject.asObserver()))
    }()
    
    init(headPageViewController: HeadPageViewController) {
        super.init(parentObject: headPageViewController, delegateProxy: RxHeadPageDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxHeadPageDelegateProxy(headPageViewController: $0) }
    }
    
    static func currentDelegate(for object: HeadPageViewController) -> HeadPageControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: HeadPageControllerDelegate?, to object: HeadPageViewController) {
        object.delegate = delegate
    }
    
    
    
}

extension RxHeadPageDelegateProxy: DelegateProxyType { }

extension RxHeadPageDelegateProxy: HeadPageControllerDelegate {
    
    func pageController(_ pageController: HeadPageViewController, willCache viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) {
        willCacheSubject.onNext(index)
    }
    
    func pageController(_ pageController: HeadPageViewController, willDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) {
        willDisplaySubject.onNext(index)
    }
    
    func pageController(_ pageController: HeadPageViewController, didDisplay viewController: (UIViewController & HeadPageChildViewController), forItemAt index: Int) {
        didDisplaySubject.onNext(index)
    }
    
    func pageController(_ pageController: HeadPageViewController, menuView isAdsorption: Bool) {
        isAdsorptionSubject.onNext(isAdsorption)
    }
    
    func pageController(_ pageController: HeadPageViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        didContentScrollSubject.onNext(scrollView)
    }
}
