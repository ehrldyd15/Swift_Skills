//
//  ViewController.swift
//  AsyncSequence
//
//  Created by Do Kiyong on 2022/12/01.
//

import UIKit

// [5단계]
// [throws 제거]
// throws를 뺄 수 있다. (컴파일 에러 안남)

struct Test: AsyncSequence, AsyncIteratorProtocol {
    typealias Element = Int
    
    var current = 1

    mutating func next() async /* ✅ throws ✅ */-> Element? { // throws 제거
        defer { current += 1 }
        
        return current
    }

    func makeAsyncIterator() -> Test {
        self
    }
}

class ViewController: UIViewController {

    let test = Test()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Task { // do-catch문도, try문도 없는 for-await-in loop를 사용할 수 있게된다.
            for try await value in test {
                if value > 10 { break }
                
                print(value)
                
                /*
                 1
                 2
                 ...
                 10
                 */
            }
        }

    }

}


// [4단계]
// [Throw Error]
// 실패(Error)가 나면 for-in loop는 종료된다. 그것을 실험해보자

//enum TestError: Error {
//    case someError
//}
//
//struct Test: AsyncSequence, AsyncIteratorProtocol {
//    typealias Element = Int
//
//    var current = 1
//
//    mutating func next() async throws -> Element? {
//        if current == 5 { throw TestError.someError } // ✅
//
//        defer { current += 1 }
//
//        return current
//    }
//
//    func makeAsyncIterator() -> Test {
//        self
//    }
//}
//
//class ViewController: UIViewController {
//
//    let test = Test()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        Task {
//            do {
//                for try await value in test {
//                    if value > 10 { break }
//
//                    print(value)
//
//                    /*
//                    1
//                    2
//                    3
//                    4
//                    someError ✅ 에러가 방출되고 for-loop 종료
//                    */
//                }
//            } catch {
//                print(error)
//            }
//        }
//
//    }
//
//}


// [3단계]
// [Conforming to the AsyncSequence Protocol]
// Custom Sequence와 마찬가지로 AsyncSequence, AsyncIteratorProtocol을 준수해야한다.
// next()와 makeAsyncIterator()를 둘 다 구현해야한다. (Sequence때는 next()만 구현하면 된다.)

//struct Test: AsyncSequence, AsyncIteratorProtocol {
//    typealias Element = Int
//
//    var current = 1
//
//    mutating func next() async throws -> Element? { // ✅ next()는 throwable한 메소드다.
//        defer { current += 1 }
//
//        return current
//    }
//
//    func makeAsyncIterator() -> Test {
//        self
//    }
//}
//
//class ViewController: UIViewController {
//
//    let test = Test()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        Task {
//            do {
//                for try await value in test {
//                    if value > 10 { break }
//
//                    print(value)
//
//                    /*
//                    1
//                    2
//                    ...
//                    10
//                    */
//                }
//            } catch {
//
//            }
//        }
//
//    }
//
//}


// [2단계]
// [AsyncSequence Operator]
// Sequence에서 사용되는 다양한 Operator를 AsyncSequence에서도 동일하게 사용할 수 있다.
// map, allSatisfy, max(by:), prefix, joined, max, dropFirst, flatMap, zip, compactMap, prefix(while:), min, reduce, min(by:), filter, contains 등

//class ViewController: UIViewController {
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
//        let endpointURL = URL(string: "https://zeddios.tistory.com")!
//
//        let lineCount = endpointURL.lines.map { $0.count } // ✅
//
//        do {
//            for try await line in lineCount {
//                print(line)

//                /*
//                15
//                16
//                6
//                ...
//                */
//            }
//        } catch {
//
//        }
//    }
//
//}


// [1단계]
// [AsyncSequence]
// AsyncSequence는 Sequence와 유사하다.
// 한번에 하나씩 단계별로 진행할 수 있는 값 목록을 제공 + 비동기성을 추가한 타입

// AsyncSequence역시 for-in loop에 사용할 수 있다.
// for value in AsyncSequence타입 {}

// 사용할 때 값이 전부 or 일부가 아직 없는 상태일 수 있기 때문에 await와 같이 쓴다.
// AsyncSequence는 for-in loop가 아닌 for-await-in loop를 사용하는 것이다.
// for await value in AsyncSequence타입 {}

// 또한, AsyncSequence가 throwable하다면, for-try-await-in loop를 사용해야한다.
// 비동기적으로 가져온다는 것 == 실패할 가능성이 있다는 걸 의미하기 때문에 try와 같이 사용한다.

// 실패하게 되면 for-loop문은 종료된다.
// 따라서 AsyncSequence가 종료되려면
// 1. 완전히 끝나거나
// 2. error가 발생하거나

//class ViewController: UIViewController {
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
//        let endpointURL = URL(string: "https://zeddios.tistory.com")!
//
//        do {
//            for try await line in endpointURL.lines {
//                // lines는 throwable 하기 때문에 for-try-await-in loop를 사용한 것을 볼 수 있다.
//                print(line)

//                /*
//                <!doctype html>
//                <html lang="ko">
//                <head>
//                ....
//                ....
//                ...
//                </html>
//                */
//            }
//        } catch {
//
//        }
//    }
//
//}

