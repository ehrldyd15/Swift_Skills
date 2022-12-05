//
//  ViewController.swift
//  AsyncStream_AsyncThrowingStream
//
//  Created by Do Kiyong on 2022/12/05.
//

import UIKit

// [3단계]
// [onTermination]
// onTermination 콜백을 설정할 수도 있다.
// termination은 AsyncStream.Continuation.Termination enum 타입 https://developer.apple.com/documentation/swift/asyncstream/continuation/termination
// 물론 AsyncThrowingStream은  AsyncThrowingStream.Continuation.Termination 타입 https://developer.apple.com/documentation/swift/asyncthrowingstream/continuation/termination
// finished(스트림이 finish메소드를 통해 종료되었을 때)와 cancelled(스트림이 취소되었을 때)가 있다.

class ViewController: UIViewController {

    let digits = AsyncStream(Int.self) { continuation in // Error 타입을 추가해준다.
        continuation.onTermination = { termination in
            switch termination {
            case .finished:
                print("finished")
            case .cancelled:
                print("cancelled")
            }
        }
        
        for digit in 1...10 {
            if digit == 5 {
                continuation.onTermination?(.cancelled) // ✅
                //continuation.onTermination?(.finished) 이것도 가능
            }
            
            print(digit) // ✅
            continuation.yield(digit)
        }
        
        print("finished before") // ✅
        continuation.finish()
        print("finish after") // ✅
        
        /*
         1
         2
         3
         4
         cancelled // onTermination callback 여기서 하고싶은 액션을 추가할 수 있다.
         5
         6
         7
         8
         9
         10
         finish before
         finished // onTermination callback 
         finish after
         */
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


// [2단계]
// [AsyncThrowingStream] https://developer.apple.com/documentation/swift/asyncthrowingstream
// AsyncStream은 에러를 throw하지 못헌다.
// 대신 AsyncThrowingStream이라는 것이 따로 있다.
// AsyncStream이랑 똑같다. 다만, 에러를 던질 수 있는 AsyncSequence를 만든다.

//enum TestError: Error {
//    case someError
//}
//
//class ViewController: UIViewController {
//
//    let digits = AsyncThrowingStream<Int, Error> { continuation in // Error 타입을 추가해준다.
//        for digit in 1...10 {
//            if digit == 5 { // 5에서 에러를 던지고 종료된다.
//                continuation.finish(throwing: TestError.someError)
//            }
//
//            continuation.yield(digit)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        Task {
//            await test()
//        }
//
//    }
//
//    func test() async {
//        do {
//            for try await digit in digits { // for-try-await-in loop를 사용
//              print(digit)
//
//                /*
//                1
//                2
//                3
//                4
//                someError
//                */
//            }
//        } catch {
//            print(error)
//        }
//    }
//
//}


// [1단계]
// [AsyncStream] https://developer.apple.com/documentation/swift/asyncstream
// 1 ~ 10 까지의 요소가 있는 AsyncSequence를 생성할때 3가지 step에 따라 AsyncStream을 만들어보자
// 1. AsyncStream을 만든다.
// 2. 타입을 지정한다. -> Int로 한다.
// 3. 클로져 안에서 하고싶은 일들을 한다.

//class ViewController: UIViewController {
//
//    let digits = AsyncStream<Int> { continuation in // continuation는 그냥 parameters [https://developer.apple.com/documentation/swift/asyncstream/continuation]
//                                                    // continuation 파라미터의 타입이 AsyncStream.Continuation이기 때문에 그냥 continuation이라고 한다.
//        for digit in 1...10 {
//            continuation.yield(digit) // yield -> 스트림에 Element를 제공
//        }
//
//        continuation.finish() // finish -> 정상적으로 스트림을 종료(sequence iterator(반복자)가 sequence를 종료하는 nil을 생성하도록 함)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        Task {
//            await test()
//        }
//
//    }
//
//    func test() async {
//        for await digit in digits {
//          print(digit)
//
//            /*
//            1
//            2
//            ...
//            10
//            */
//        }
//    }
//
//}

