//
//  ErrorTracker.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/28.
//

import Foundation
import RxSwift
import RxCocoa

final class ErrorTracker: SharedSequenceConvertibleType {
    private let _relay: PublishRelay<Error> = .init()
    
    func acceptError<O: ObservableType>(from source: O) -> Observable<O.Element> {
        return source.do(onError: { self._relay.accept($0) })
    }
    
    func asSharedSequence() -> SharedSequence<SignalSharingStrategy, Error> {
        return _relay.asSignal()
    }

    func asObservable() -> Observable<Error> {
        return _relay.asObservable()
    }
}

extension ObservableType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.acceptError(from: self)
    }
}
