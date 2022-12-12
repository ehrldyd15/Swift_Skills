//
//  ReactorKit_TutorialTests.swift
//  ReactorKit_TutorialTests
//
//  Created by Do Kiyong on 2022/12/12.
//

import XCTest
@testable import ReactorKit_Tutorial

final class ReactorKit_TutorialTests: XCTestCase {
    /*
     [테스트 준비]
     - sut: System Under Test (테스트 대상의 변수명)
     - View를 구성할 때 storyboard를 이용했으므로, storyboard 객체 선언 `sut`
     */
    let sut = UIStoryboard(name: "CounterViewController", bundle: nil)
    
    /*
     테스트 코드 메소드 시그니처 작성
     감소 버튼을 탭한 경우, 작업단위 (Mutation) 값이 decrease로 잘 들어오는지 테스트
     */
    func testAction_whenDidTapDecreaseButtonInView_thenMutationIsDecreaseInReactor() {
        // Given
        let counterReactor = CounterViewReactor()
        counterReactor.isStubEnabled = true
        
        let counterViewController = sut.instantiateViewController(withIdentifier: "CounterViewController") as! CounterViewController
        // 주의해야할 점은 ViewController를 storyboard 인스턴스로 생성 후, loadViewIfNeeded()를 호출해주어야 IBOutlet 인스턴스가 생성되므로 호출
        counterViewController.loadViewIfNeeded() // IBOutlet과 Action을 구성하기 위해서 호출
        counterViewController.reactor = counterReactor
        
        // When
        counterViewController.decreaseButton.sendActions(for: .touchUpInside)
        
        // Then
        XCTAssertEqual(counterReactor.stub.actions.last, .decrease)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
