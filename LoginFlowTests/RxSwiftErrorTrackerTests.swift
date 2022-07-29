//
//  RxSwiftErrorTrackerTests.swift
//  LoginFlowTests
//
//  Created by Jaewon on 2022/07/29.
//

import XCTest
import RxSwift
import RxCocoa
@testable import LoginFlow

class RxSwiftErrorTrackerTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = true
    }
    
    func test_errorTracker() {
        // arrange
        enum TestError: Error {
            case correctError
            case wrongError
        }
        
        let disposeBag: DisposeBag = .init()
        let errorTracker: NewErrorTracker = .init()
        let testSubject: PublishSubject<Int> = .init() // onNext, onError 발생 목적
        
        let expectedOnNextValue: [Int] = [1, 0]
        var actualOnNextValue: [Int] = .init()
        
        let expectedError: TestError = .correctError
        var actualError: TestError = .wrongError
        
        testSubject
            .newTrackError(errorTracker)
            .catchAndReturn(0)
            .subscribe(
                onNext: { value in
                    actualOnNextValue.append(value)
                }
            )
            .disposed(by: disposeBag)
        
        errorTracker
            .emit(
                onNext: { error in
                    actualError = error as! TestError
                }
            )
            .disposed(by: disposeBag)
        
        // act
        testSubject.onNext(1)
        testSubject.onError(TestError.correctError)
        testSubject.onNext(2)
        
        // assert
        XCTAssertEqual(expectedOnNextValue, actualOnNextValue)
        XCTAssertEqual(expectedError, actualError)
    }
}
