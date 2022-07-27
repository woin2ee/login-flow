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
}
