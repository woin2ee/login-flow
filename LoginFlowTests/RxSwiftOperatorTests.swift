//
//  RxSwiftOperatorTests.swift
//  RxSwiftOperatorTests
//
//  Created by Jaewon on 2022/07/25.
//

import XCTest
import RxSwift
import RxCocoa

class RxSwiftOperatorTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = true
    }
    
    func test_map_with_error() throws {
        // arrange
        let expectedValue = [2, 3, 4, 0]
        var actualValue = [Int]()
        
        enum AnyError: Error {
            case someError
        }
        
        let disposeBag = DisposeBag.init()
        
        let subject = PublishSubject<Int>.init()
        
        let driver = subject
            .map { self.increaseOne(num: $0) }
            .asDriver(onErrorJustReturn: 0)
        
        driver
            .drive(
                onNext: {
                    actualValue.append($0)
                }
            )
            .disposed(by: disposeBag)
        
        // act
        [1, 2, 3].forEach {
            subject.onNext($0)
        }
        subject.onError(AnyError.someError)
        
        // assert
        XCTAssertEqual(expectedValue, actualValue)
    }
    
    private func increaseOne(num: Int) -> Int {
        return num + 1
    }
    
    func test_emit_error_in_driver() {
        // arrange
        let disposeBag: DisposeBag = .init()
        
        let publishSubject: PublishSubject<Int> = .init()
        let button: UIButton = .init()
        
        let expectedTapCount: Int = 3
        var actualTapCount: Int = 0
        
        let expectedValue: Int = 0
        var actualValue: Int = 0
        
        enum TestError: Error {
            case testError
        }
        
        button.rx.tap
            .subscribe(
                onNext: {
                    publishSubject.onError(TestError.testError)
                }
            )
            .disposed(by: disposeBag)
        
        publishSubject
            .asDriver(onErrorJustReturn: -1)
            .drive(
                onNext: { value in
                    actualTapCount += 1
                    actualValue = value
                }
            )
            .disposed(by: disposeBag)
        
        // act
        for _ in 0..<expectedTapCount {
            button.sendActions(for: .touchUpInside)
        }
        
        // assert
        XCTAssertEqual(expectedTapCount, actualTapCount)
        XCTAssertEqual(expectedValue, actualValue)
    }
}
