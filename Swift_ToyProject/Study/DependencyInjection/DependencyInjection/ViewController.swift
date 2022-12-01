//
//  ViewController.swift
//  DependencyInjection
//
//  Created by Do Kiyong on 2022/11/30.
//

import UIKit

// [ 의존 관계 역전 법칙 (DIP)]
// 상위 계층(정책결정)이 하위 계층(세부사항)에 의존하는 전통적인 의존관계를 반전시킴으로써
// 상위 계층이 하위 계층의 구현으로부터 독립되게 할 수 있는 구조를 말한다. (아래의 두 가지 특징이 있다)

// 1. 상위 모듈은 하위 모듈에 의존해서는 안된다. 상위 모듈과 하위 모듈은 모두 추상화에 의존해야 한다.
// 2. 추상화는 세부 사항에 의존해서는 안된다. 세부사항이 추상화에 의존해야 한다.

// 앞선 예시는 B 클래스가 A 클래스에 의존하는 (B -> A) 구조였다면,
// 의존 관계 역전 법칙에서는 어떤 추상화된 인터페이스(Swift 에서는 프로토콜)에 A, B 객체가 모두 의존
// 즉, (A -> 프로토콜 <- B)하고 있는 구조라고 볼 수 있다.
protocol Menu {
    func printCoffee()
    func printMeal()
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = Eat(coffee: "아메리카노", meal: "피자")
        let anotherMenu = Eat(coffee: "라떼", meal: "햄버거")
        
        var suhshin = Person(todayEat: menu)

        suhshin.printCoffee() // print 아메리카노
        suhshin.changeMenu(menu: anotherMenu)
        suhshin.printCoffee() // print 라떼

    }

}

class Eat: Menu {
    var coffee: String
    var meal: String
    
    init(coffee: String, meal: String) {
        self.coffee = coffee
        self.meal = meal
    }
    
    func printCoffee() {
        print(coffee)
    }
    
    func printMeal() {
        print(meal)
    }
}

struct Person {
    var todayEat: Menu
    
    func printCoffee() {
        todayEat.printCoffee()
    }
    
    func printMeal() {
        todayEat.printMeal()
    }
    
    // 구조체 메소드가 구조체 내부에서 데이터 수정을 할 떄는 Mutating 키워드를 선언해줘야 한다.
    mutating func changeMenu(menu: Menu) {
        self.todayEat = menu
    }
    
}

// [주입]
// 내부가 아닌 외부에서 객체를 생성해서 넣어주는 것을 주입한다고 표현한다.
// 여기서는 외부에서 Int를 생성해 A클래스에 주입한다.
//class ViewController: UIViewController {
//
//    let a = A(num: 3) // 외부에서 객체 생성
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        print(a.num) // 결과 값: 3
//
//        a.setNum(num: 5) // 객체 생성
//
//        print(a.num) // 결과 값: 5
//
//    }
//
//}
//
//class A {
//    var num: Int
//
//    init(num: Int) {
//        self.num = num
//    }
//
//    func setNum(num:Int) {
//        self.num = num
//    }
//}

// [의존성]
// 객체끼리 의존하는 경우 많은 문제가 야기된다.
// A클래스에 문제가 생긴다면 이를 의존하고 있는 B클래스에도 문제가 생길 수 있어서 재사용성이 낮아진다.
//class ViewController: UIViewController {
//
//    let b = B()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        print(b.internalVariable.num) // 의존성이 강함
//
//    }
//
//}
//
//class A: UIViewController {
//    var num: Int = 1
//}
//
//class B: UIViewController {
//    var internalVariable = A()
//}

