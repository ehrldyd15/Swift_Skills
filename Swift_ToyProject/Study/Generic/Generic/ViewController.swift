//
//  ViewController.swift
//  Generic
//
//  Created by Do Kiyong on 2023/05/24.
//

import UIKit

// https://jusung.gitbook.io/the-swift-language-guide/language-guide/22-generics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var a = 10
        var b = 20
        swapTwoInts(&a, &b)
        print("a: ", a)
        print("b: ", b)
        
        
        var someInt = 1
        var aotherInt = 2
        // 실제 함수를 호출할 때 Type Parameter인 T의 타입이 결정
        swapTwoValues(&someInt,  &aotherInt)
        print("someInt: ", someInt)
        print("aotherInt: ", aotherInt)
        
        var someString = "Hi"
        var aotherString = "Bye"
        swapTwoValues(&someString, &aotherString)
        print("someString: ", someString)
        print("aotherString: ", aotherString)
        
        var stackOfStrings = Stack<String>()
        stackOfStrings.push("uno")
        stackOfStrings.push("dos")
        stackOfStrings.push("tres")
        stackOfStrings.push("cuatro")
        print("stackOfStrings: ", stackOfStrings)
        
        let fromTheTop = stackOfStrings.pop()
        print("stackOfStrings: ", stackOfStrings)
        
        if let topItem = stackOfStrings.topItem {
            print("The top item on the stack is \(topItem).")
        }
        
        let doubleIndex = findIndex(of: 0.1, in: [3.14159, 0.1, 0.25])
        print("doubleIndex: ", doubleIndex ?? 0)
        // doubleIndex is an optional Int with no value, because 9.3 isn't in the array
        let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
        print("stringIndex: ", stringIndex ?? "")
        // stringIndex is an optional Int containing a value of 2
        
    }

    
    // 파라미터 모두 Int형일 경우엔 문제 없이 돌아감
    // 만약 파라미터 타입이 Double, String일 경우엔 사용할 수 없음
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
       let tempA = a
        
       a = b
       b = tempA
    }
    
    // T -> Type Parameter(실제 함수가 호출될 때 해당 매개변수의 타입으로 대체되는 Placeholder)
    func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
       let tempA = a
        
       a = b
       b = tempA
    }
    
    // ✅ 타입 제한 문법 (Type Constraint Syntax)
    // == 등호를 사용하기 위해서 Equatable프로토콜을 준수해야한다.
    func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }

        return nil
    }



}

// ✅ 제네릭 타입(Generic Type)
// 구조체, 클래스, 열거형 타입에도 선언할 수 있는데, 이것을 "제네릭 타입(Generic Type)" 이라고 함
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// ✅ 제네릭 타입의 확장 (Extending a Generic Type)
// 익스텐션을 이용해 제네릭 타입을 확장할 수 있습니다. 이때 원래 선언한 파라미터 이름을 사용합니다. 여기서는 Element라는 파라미터를 사용합니다.
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}


