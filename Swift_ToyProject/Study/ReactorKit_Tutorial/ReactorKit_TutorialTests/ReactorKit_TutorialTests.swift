//
//  ReactorKit_TutorialTests.swift
//  ReactorKit_TutorialTests
//
//  Created by Do Kiyong on 2022/12/12.
//

import XCTest
@testable import ReactorKit_Tutorial
import RxSwift

final class ReactorKit_TutorialTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    /*
     [테스트 준비]
     - sut: System Under Test (테스트 대상의 변수명)
     - View를 구성할 때 storyboard를 이용했으므로, storyboard 객체 선언 `sut`
     */
    let sut = UIStoryboard(name: "CounterViewController", bundle: nil)
    
    /*
     1. 테스트 View -> Reactor
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
    
    /*
     2. 테스트 Reactor -> View
     Reactor에서 loding 상태가 바뀐 경우, View에도 반영되는지 확인
     감소 버튼을 탭한 경우, 작업단위 (Mutation) 값이 decrease로 잘 들어오는지 테스트
     */
    func testState_whenChangeLoadingStateToTrueInReactor_thenActivityIndicatorViewIsAnimatingInView() {
        // Given
        let counterReactor = CounterViewReactor()
        counterReactor.isStubEnabled = true
        
        let counterViewController = sut.instantiateViewController(withIdentifier: "CounterViewController") as! CounterViewController
        counterViewController.loadViewIfNeeded()
        counterViewController.reactor = counterReactor
        
        // When
        counterReactor.stub.state.value = CounterViewReactor.State(value: 0, isLoading: true)
        
        // Then
        XCTAssertEqual(counterViewController.activityIndicatorView.isAnimating, true)
    }
    
    /*
     3. 테스트 Reactor
     action을 받으면 비즈니스 로직(Mutation)이 잘 처리되어 State값이 기대하는 값으로 변경되는지 확인
     Reactor에서 특정 action을 주고, 내부적으로 mutate(), reduce()를 통해서 state값이 기대하는 값으로 변경되는지 확인
     */
    func testReactor_whenExcuteIncreaseButtonTapActionInView_thenStateIsLoadingInReactor() {
        // Given
        let reactor = CounterViewReactor()
        
        // When
        reactor.action.onNext(.increase)
        
        // Then
        XCTAssertEqual(reactor.currentState.isLoading, true)
    }
    
    /*
     3. 테스트 Reactor
     비동기처리인 경우 테스트 방법 - increase 액션이 발생했을 때, 최종적으로 value값이 변화하는지 테스트
     */
    func testReactor_whenExecuteIncreaseButtonTapActionInView_thenStateValueIsChanged() {
      // Given
        let reactor = CounterViewReactor()
        let expectation = XCTestExpectation(description: "Test Description")
        reactor.state.map(\.value)
          .distinctUntilChanged()
          .filter { $0 == 1 }
          .subscribe(onNext: { value in expectation.fulfill() })
          .disposed(by: self.disposeBag)
        
        // When
        reactor.action.onNext(.increase)
        
        // Then
        wait(for: [expectation], timeout: 3.0)
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
