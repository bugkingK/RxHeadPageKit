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
    where O.Element == RxHeadPageConfigurationModel {
        return { source in
            let dataSource = RxHeadPageViewControllerReactiveArrayDataSource { _, viewController in
                return viewController
            }
            return self.configuration(dataSource: dataSource)(source)
        }
    }
    
    private func configuration<DataSource: HeadPageControllerDataSource & RxHeadPageViewControllerDataSourceType, O: ObservableType>
    (dataSource: DataSource)
    -> (_ source: O) -> Disposable where  O.Element == DataSource.Element {
        RxHeadPageDataSourceProxy.setCurrentDelegate(nil, to: base)
        return { [base] source in
            RxHeadPageDataSourceProxy.setCurrentDelegate(dataSource, to: base)
            
            let subscription = source
                .asObservable()
                .observeOn(MainScheduler())
                .catchError { _ in
                    return Observable.empty()
                }
                .concat(Observable.never())
                .takeUntil(base.rx.deallocated)
                .subscribe { (event) in
                    dataSource.pageController(base, observedEvent: event)
                }
            
            return Disposables.create { [weak base] in
                guard let base = base else { return }
                subscription.dispose()
                base.view.layoutIfNeeded()
                
                RxHeadPageDataSourceProxy.setCurrentDelegate(dataSource, to: base)
            }
        }
    }
    
    private var dataSource: DelegateProxy<HeadPageViewController, HeadPageControllerDataSource> {
        return RxHeadPageDataSourceProxy.proxy(for: self.base)
    }
    
    private var delegate: RxHeadPageDelegateProxy {
        return RxHeadPageDelegateProxy.proxy(for: self.base)
    }
    
    public var willCache: ControlEvent<Int> {
        return delegate.willCache
    }

    public var willDisplay: ControlEvent<Int> {
        return delegate.willDisplay
    }
    
    public var didDisplay: ControlEvent<Int> {
        return delegate.didDisplay
    }
    
    public var isAdsorption: ControlEvent<Bool> {
        return delegate.isAdsorption
    }
    
    public var didContentScroll: ControlEvent<UIScrollView> {
        return delegate.didContentScroll
    }
    
}
