//
//  Rx+HeadPageViewController.swift
//  
//
//  Created by Bugking on 2020/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import HeadPageKit

extension Reactive where Base: HeadPageViewController {
    
    public func configuration<O: ObservableType>() -> (_ source: O) -> Disposable
    where O.Element == HeadPageConfigModel {
        return { source in
            let dataSource = RxHeadPageViewControllerReactiveArrayDataSource { _, viewController in
                return viewController
            }
            return self.configuration(dataSource: dataSource)(source)
        }
    }
    
    private func configuration<DataSource: HeadPageViewControllerDataSource & RxHeadPageViewControllerDataSourceType, O: ObservableType>
    (dataSource: DataSource)
    -> (_ source: O) -> Disposable where  O.Element == DataSource.Element {
        RxHeadPageDataSourceProxy.setCurrentDelegate(nil, to: base)
        return { [base] source in
            RxHeadPageDataSourceProxy.setCurrentDelegate(dataSource, to: base)
            
            let subscription = source
                .asObservable()
                .observe(on: MainScheduler())
                .catch { _ in Observable.empty() }
                .concat(Observable.never())
                .take(until: base.rx.deallocated)
                .subscribe { dataSource.pageController(base, observedEvent: $0) }
            
            return Disposables.create { [weak base] in
                guard let base = base else { return }
                subscription.dispose()
                base.view.layoutIfNeeded()
                
                RxHeadPageDataSourceProxy.setCurrentDelegate(dataSource, to: base)
            }
        }
    }
    
    private var dataSource: DelegateProxy<HeadPageViewController, HeadPageViewControllerDataSource> {
        return RxHeadPageDataSourceProxy.proxy(for: self.base)
    }
    
    private var delegate: RxHeadPageDelegateProxy {
        return RxHeadPageDelegateProxy.proxy(for: self.base)
    }
    
    public var willCache: ControlEvent<Int> {
        return .init(events: delegate.willCache.asObserver())
    }

    public var willDisplay: ControlEvent<Int> {
        return .init(events: delegate.willDisplay.asObserver())
    }
    
    public var didDisplay: ControlEvent<Int> {
        return .init(events: delegate.didDisplay.asObserver())
    }
    
    public var isAdsorption: ControlEvent<Bool> {
        return .init(events: delegate.isAdsorption.asObserver())
    }
    
    public var didContentScroll: ControlEvent<UIScrollView> {
        return .init(events: delegate.didContentScroll.asObserver())
    }
    
}
