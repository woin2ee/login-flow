//
//  ErrorTracker.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/28.
//

import Foundation
import RxSwift
import RxCocoa

final class NewErrorTracker: SharedSequenceConvertibleType {
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
    func newTrackError(_ errorTracker: NewErrorTracker) -> Observable<Element> {
        return errorTracker.acceptError(from: self)
    }
}



final class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
}
