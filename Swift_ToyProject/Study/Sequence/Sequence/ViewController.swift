//
//  ViewController.swift
//  Sequence
//
//  Created by Do Kiyong on 2022/12/01.
//

import UIKit

// [2단계]
// [Conforming to the Sequence Protocol]

// 아래에서 Test가 Sequence를 준수하기 때문에 required 메소드인 makeIterator()를 구현하지 않아도 됨
//struct Test: Sequence {
//    func makeIterator() -> some IteratorProtocol {
//        return TestIterator()
//    }
//}

struct Test: Sequence, IteratorProtocol {
    typealias Element = Int

    var current = 1

    mutating func next() -> Element? {
        if current > 10 {
            return nil
        } // 무한루프를 방지하기 위하여..

        defer {
            current += 1
        } // defer는 함수 종료 직전에 호출된다.

        return current
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let test = Test()

        for value in test {
            print(value)
        }
        // print 1
        // ......
        // print 10

    }

}


// [1단계]
// [Sequence]
// Swift에서 Collection Type들인 Array, Set, Dictionary는 Collection프로토콜을 채택하고있다.
// 그리고 이 Collection프로토콜은 Sequence를 conform하고 있다.

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        // Sequence는 한번에 하나씩 단계별로 진행할 수 있는 값 목록(list of values)
//        // 이 Sequence의 요소를 반복하는 가장 일반적인 방법은 for-in loop를 사용하는 것이다.
//        let numbers = 1...3
//
//        for number in numbers {
//            print(number)
//        }
//        // print 1
//        // print 2
//        // print 3
//    }
//
//
//}

