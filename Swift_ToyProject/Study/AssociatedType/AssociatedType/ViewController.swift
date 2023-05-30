//
//  ViewController.swift
//  AssociatedType
//
//  Created by Do Kiyong on 2023/05/24.
//

// https://jusung.gitbook.io/the-swift-language-guide/language-guide/22-generics

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

// ✅ 프로토콜에 연관 타입의 제한 사용하기 (Using a Protocol in Its Associated Type’s Constraints)
// 연관 타입을 적용할 수 있는 타입에 조건을 걸어 제한을 둘 수 있다.
// 조건을 붙일때는 where구문을 사용한다. 이 조건에는 특정 탑입인지의 여부, 특정 프로토콜을 따르는지 여부 등이 사용될 수 있다.
// 다음은 Suffix가 SuffixableContainer프로토콜을 따르고 Item타입이 반드시 Container의 Item타입이어야 한다는 조건을 추가한 것이다.

//protocol SuffixableContainer: Container {
//    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
//
//    func suffix(_ size: Int) -> Suffix
//}
//
//extension Stack: SuffixableContainer {
//    func suffix(_ size: Int) -> Stack {
//        var result = Stack()
//
//        for index in (count-size)..<count {
//            result.append(self[index])
//        }
//
//        return result
//    }
//    // Inferred that Suffix is Stack.
//}
//
//var stackOfInts = Stack<Int>()
//
//stackOfInts.append(10)
//stackOfInts.append(20)
//stackOfInts.append(30)
//
//let suffix = stackOfInts.suffix(2)
//// suffix contains 20 and 30

// ✅ Adding Constraints to an Associated TypePermalink (타입 제약)
// 이 프로토콜을 준수하기 위해서, 컨테이너의 Item 타입은 Equatable 프로토콜을 준수해야 한다.

protocol Container {
    associatedtype Item: Equatable
    
    mutating func append(_ item: Item)
    
    var count: Int { get }
    
    subscript(i: Int) -> Item { get }
}

// ✅ 연관 타입의 실 사용 (Associated Types in Action)

//protocol Container {
//    associatedtype Item
//
//    mutating func append(_ item: Item)
//
//    var count: Int { get }
//
//    subscript(i: Int) -> Item { get }
//}
//
//// IntStack 타입은 Container 프로토콜을 체택하고 세 가지 필수 요구사항을 준수하고 있고,
//// associatedtype인 Item 사용하기 위해 Int 타입을 사용하고 있다.
//// typealias Item = Int 는 프로토콜을 준수하기 위해서 추상 타입인 Item을 Int 로 바꿔 사용하기 위한 구문이다.
//// Swift의 타입 추론 덕분에 이 구문은 생략 가능하다.
//struct IntStack: Container {
//    // original IntStack implementation
//    var items = [Int]()
//
//    mutating func push(_ item: Int) {
//        items.append(item)
//    }
//
//    mutating func pop() -> Int {
//        return items.removeLast()
//    }
//
//    // conformance to the Container protocol
//    typealias Item = Int
//
//    mutating func append(_ item: Int) {
//        self.push(item)
//    }
//
//    var count: Int {
//        return items.count
//    }
//
//    subscript(i: Int) -> Int {
//        return items[i]
//    }
//}
//
//// generic Stack 타입을 통해서도 Container 프로토콜을 준수할 수 있다.
//struct Stack<Element>: Container {
//    // original Stack<Element> implementation
//    var items = [Element]()
//
//    mutating func push(_ item: Element) {
//        items.append(item)
//    }
//
//    mutating func pop() -> Element {
//        return items.removeLast()
//    }
//
//    // conformance to the Container protocol
//    mutating func append(_ item: Element) {
//        self.push(item)
//    }
//
//    var count: Int {
//        return items.count
//    }
//
//    subscript(i: Int) -> Element {
//        return items[i]
//    }
//}


