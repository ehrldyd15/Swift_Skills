//
//  ViewController.swift
//  LazyVariables
//
//  Created by Do Kiyong on 2022/12/13.
//  [참고자료]
//  https://baked-corn.tistory.com/30?category=718234
//  https://baked-corn.tistory.com/45

import UIKit

// [8단계]
// [Lazy variables]
// lazy 변수는 처음 사용되기 전까지는 연산이 되지 않는다는 것이다.

// 1. lazy는 반드시 var와 함께 쓰여야 한다.
// -> 기본적으로 lazy로 선언된 변수는 초기에는 값이 존재하지 않고 이후에 값이 생기는 것이기 때문에 let 으로는 선언될 수 없다.

// 2. struct, class
// -> 기본적으로 lazy는 struct와 class에서만 사용할 수 있다.

// 3. lazy vs Computed Property
// -> Computed Property에는 lazy 키워드를 사용할 수 없다.
//    lazy는 처음 사용될 때 메모리에 값을 올리고 그 이후 부터는 계속해서 메모리에 올라온 값을 사용한다.
//    사용할 때마다 값을 연산하여 사용하는 Computed Property에는 사용할 수 없다.

// 4. lazy and closure
// -> lazy에 어떤 특별한 연산을 통해 값을 넣어주기 위해서는 코드 실행 블록인 closure를 사용한다.
//    class나 struct의 다른 프로퍼티의 값을 lazy 변수에서 사용하기 위해서는 closure내에서 self를 통해 접근이 가능하다.
//    기본적으로 일반 변수들은 클래스가 생성된 이후에 접근이 가능하기 때문에 클래스내의 다른 영역(메소드, 일반 프로퍼티)에서는 self를 통해 접근할 수 없지만
//    lazy키워드가 붙으면 생성 후 추후에 접근할 것이라는 의미이기 때문에 closure내에서 self로 접근이 가능하다.

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var me = Person(name:"John")

//        print(me.greeting)
        print(me.greeting())

        me.name = "James"

//        print(me.greeting)
        print(me.greeting())

    }

}

class Person {
    var name: String
    
    // self.name을 통해 name프로퍼티에 접근하는 것을 볼 수 있는데
    // 아래의 단계들에서 클래스 내부의 클로저에서 클래스 객체를 self 로 참조한다면 메모리 누수가 발생하는 위험이 있다는 것을 알았다.
    // 하지만 뒤의 ()를 통해 그 즉시 실행하고 결과를 돌려주고 끝나버리기 때문에 메모리 누수의 걱정은 없다.
//    lazy var greeting: String = {
//        // 프로퍼티가 James으로 변경이 되어도 처음 사용할 때 메모리에는 John이 올라가 있기 때문에 John이 출력이 된다.
//        return "Hello my name is \((self.name))"
//
//        // [출력]
//        // Hello my name is John
//        // Hello my name is John
//    }() // ✅
    
    lazy var greeting: () -> String = { [weak self] in
        // 만일 변수가 lazy var greeting:String이 아닌 lazy var greeting: () -> String으로
        // 클로저 실행의 결과를 담는 것이 아닌 클로저 자체를 담고 있는 변수라면 반드시 [weak self]를 통해 메모리 누수를 방지해주어야 한다.
        
        // 값이 아닌 클로저 자체가 메모리에 올라가 있고, self 는 내부에서 계속해서 클래스를 참조하기 때문에
        // 계속 John이 출력이 되는 것이 아닌 James가 출력이 되는 것이다.
        return "Hello my name is \(((self?.name))!)"
        
        // [출력]
        // Hello my name is John
        // Hello my name is James
    }
  
    init(name: String){
        self.name = name
    }
}


//// [7단계]
//// [Detecting retain cycles by using log messages in deinit]
//// 순환참조를 감지하는 방법은 deinit에 로그메시지를 출력하는 코드를 넣는 것이다.
//// 이는 매우 효과적인 방법이다.
//
//// View Controller마다 이러한 메소드를 작성해주는 것이 좋다.
//// 예를 들어 View Controller를 pop한다면 Log 메시지는 출력이 되어야 한다.
//// 만일 출력이 된다면 프로그램이 잘 돌아가고있음을 알 수 있다.
//
//class ViewController: UIViewController {
//
//    var testClass: TestClass? = TestClass()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        testClass = nil
//
//    }
//
//}
//
//class TestClass {
//
//    init() {
//        print("init")
//    }
//
//    deinit {
//        print("deinit")
//    }
//
//}


//// [6단계]
//// [Common Scenarios for Retain Cycles : Closures]
//// Closure는 Retain Cycle이 빈번히 일어나는 시나리오 중 하나이다.
//
//class ViewController: UIViewController {
//
//    var testClass: TestClass? = TestClass()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        testClass = nil
//
//        // TestClass의 객체의 내부에서 Closure로, Closure에서 TestClass객체로 강한 참조를 하고 있기 때문에
//        // TestClass 객체의 메모리가 해제되지 않는다.
//
//        // [출력]
//        // init
//
//        // Closure 역시 Class와 마찬가지로 Reference Type 이기 때문에
//        // ✅[weak self]✅를 capture해줌으로써 해결할 수 있다.
//        // 이렇게 되면 TestClass Instance는 Closure를 강한참조, Closure는 TestClass Instance를 약한참조 하게된다.
//
//        // [출력]
//        // init
//        // deinit
//
//        testClass?.doSomething()
//        testClass = nil
//
//        // [출력]
//        // init
//        // deinit
//    }
//
//}
//
//class TestClass {
//
//    var aBlock: (()->())? = nil
//
//    let aConstant = 5
//
//    init() {
//        print("init")
//
////        aBlock = { [weak self] in // ✅ [weak self]를 추가하여 약한참조를 걸어준다.
////            // 그러나 Closure를 사용한다고 해서 항상 순환참조가 발생하는것은 아니다.
////            print(self?.aConstant)
////        }
//
////        let aBlock = { // ✅ [weak self]를 추가할 필요가 없다.
////            // Closure 블록을 locally하게만 사용한다면 self를 weak하게 capture할 필요가 없다.
////            // 그 이유는 Closure 블록에 대한 강한참조가 존재하지 ㅇ낳기 때문이다.
////
////            // 블록 자체는 블록 내부에서 self, 즉 TestClass 객체를 강하게 참조하지만
////            // Closure자체는 메소드 지역안에 존재하기 때문에 메소드가 return되면 메모리에서 해제됩니다.
////            print(self.aConstant)
////        }
//    }
//
//    deinit {
//        print("deinit")
//    }
//
//    func doSomething(){
//        UIView.animate(withDuration: 5) {
//            let aConstant = self.aConstant
//
//            // fancy animation ... .
//
//            // Closure블록에 대한 강한 참조가 존재하지 않는다면 Retain Cycle에 대해 걱정할 필요가 없다.
//            // 또한, unowned 역시 weak대신 사용할 수 있고 이전에 사용했던 예제는 unowned보다 안전하게 사용이 가능하다.
//        }
//    }
//
//}


//// [5단계]
//// [Common Scenarios for Retain Cylces : Delegates]
//// 순환참조가 일어나는 흔한 시나리오는 delegate의 사용이다.
//// 프로그램에 자식 view controller를 갖고 있는 부모 view controller가 있다고 가정하고
//// 부모 view controller는 특정 상황에서의 정보를 얻기 위해 스스로 본인을 자식 view controller의 대리자로 설정할 것이다.
//
//class ParentViewController: UIViewController, ChildViewControllerProtocol {
//
//    let childViewController = ChildViewController() // 강한참조
//
//    func prepareChildViewController() {
//        childViewController.delegate = self
//    }
//
//}
//
//protocol ChildViewControllerProtocol {
//    // important functions
//}
//
//class ChildViewController: UIViewController {
//
//    var delegate: ChildViewControllerProtocol?
//    // 강한참조
//    // 이런 방법으로 코드를 작성한다면 ParentViewController가 pop된 이후에 발생하는 Retain Cycle로 인해 메모리 누수가 발생하게된다.
//
//    weak var delegate: ChildViewControllerProtocol?
//    //  delegate 프로퍼티를 반드시 weak으로 선언해야한다. -> 약한참조
//
//    // 참고로 UITableView의 정의를 보게 된다면 delegate와 dataSource 프로퍼티가 weak으로 선언된 것을 확인하실 수 있다.
//    // weak public var dataSource: UITableViewDataSource?
//    // weak public var delegate: UITableViewDelegate?
//    // 그러므로 delegate를 선언해야하는 거의 대부분의 상황에서 weak을 사용함으로써 순환참조를 피할 수 있다.
//}


// [4단계]
// [Unowned]
/*
weak 밖에도 변수에 적용할 수 있는 unowned라는 옵션이 존재한다.
weak과 매우 비슷한 역할을 하지만 한가지 예외가 있다. unowned로 선언된 변수는 nil로 될 수 없다.
그러므로 unowned 변수는 optional로 선언되어서는 절대 안된다.
하지만 메모리가 해제된 영역의 접근을 시도한다면 어플리케이션은 runtime exception을 발생시킨다.
이 뜻은 unowned는 해제된 메모리 영역을 접근하지 않는다는 확실한 경우만 사용해야한다.
일반적으로 weak을 사용하는 것이 보다 안전하다.
하지만 하지만 변수가 weak이 되길 원하지 않고 또한 해당 변수가 가리키는 객체의 메모리가 해제된 이후에는
해당 영역을 가리키지 않는다는 확신이 있다면 당신은 unowned를 사용할 수 있다.

이는 implicitly unwrapping optional과 try!와 같이 사용은 할 수 있으나 대부분의 상황에서는 좋지 않은 방법이다.
*/


//// [3단계]
//// [Weak]
//// 참조를 weak으로 선언한다면 이것은 “강한 참조”가 되지 않는다.
//
//class ViewController: UIViewController {
//
//    var testClass1: TestClass? = TestClass()
//    var testClass2: TestClass? = TestClass()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        testClass1?.testClass = testClass2
//        testClass2?.testClass = testClass1
//
//        testClass1 = nil
//        testClass2 = nil
//
//        // testClass1     TestClass Instance
//        //                     |      |
//        //                  약한참조   약한참조
//        //                     |      |
//        // testClass2      TestClass Instance
//
//        // 오직 약한 관계만이 남아있다면 객체들의 메모리는 해제될 것이다.
//        // 즉 weak reference는 참조는 할 수 있지만 Reference Count가 증가되지 않는다.
//
//        // [출력]
//        // init
//        // init
//        // deinit
//        // deinit
//
//        // 객체의 메모리가 해제된 후 그에 대응하는 변수는 자동으로 nil이 될 것이다.
//        // 만일 변수가 이미 메모리가 해지된 객체의 영역을 가리키고 있다면 프로그램은 runtime exception을 발생시키기 때문이다.
//        // 또한 optional 타입만이 nil값이 될 수 있기 때문에 모든 weak 참조 변수는 반드시 optional 타입이어야 한다.
//
//    }
//
//}
//
//class TestClass {
//    weak var testClass: TestClass? = nil // ✅
//
//    init() {
//        print("init")
//    }
//
//    deinit {
//        print("deinit")
//    }
//
//}


//// [2단계]
//// [What is Retain Cycle?]
//// ARC의 원리는 제대로 작동을 하고 대부분의 경우 여러분은 이에 관해서 생각할 필요가 없다.
//// 그러나 이러한 ARC가 작동하지 않는 상황이 몇몇 있으니 살펴보도록 하자
//
//class ViewController: UIViewController {
//
//    var testClass1: TestClass? = TestClass()
//    var testClass2: TestClass? = TestClass()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        testClass1?.testClass = testClass2
//        testClass2?.testClass = testClass1
//
//        // testClass1 -> 강한참조 -> TestClass Instance
//        //                            |      |
//        //                         강한참조   강한참조
//        //                            |      |
//        // testClass2 -> 강한참조 -> TestClass Instance
//
//        // [출력]
//        // init
//        // init
//
//        testClass1 = nil
//        testClass2 = nil
//
//        // testClass1     TestClass Instance
//        //                     |      |
//        //                   강한참조   강한참조
//        //                     |      |
//        // testClass2      TestClass Instance
//
//        // 각각의 객체는 강한 참조를 하나씩 잃었다.
//        // 하지만 각각의 객체는 아직 내부적으로 한개씩의 참조를 갖고 있다.
//        // 이는 두 객체들의 메모리가 해제되지 않을 것이라는걸 의미한다.
//        // 심지어 더 심각한 것은 이 두 객체에 대한 참조는 우리의 코드에서 더 이상 존재하지 않는다는 것이다.
//        // 즉 이 두 객체의 메모리를 해제하는 방법은 존재하지 않는다.
//        // 이것을 메모리 누수(Memory Leak)이라고 한다.
//
//        // [출력]
//        // init
//        // init
//
//    }
//
//}
//
//class TestClass {
//    var testClass: TestClass? = nil // ✅
//
//    init() {
//        print("init")
//    }
//
//    deinit {
//        print("deinit")
//    }
//
//}


//// [1단계]
//// [How does memory management work in Swift]
//// ARC(Automatic Reference Counting)는 대부분의 메모리를 관리해준다.
//// 기본적으로 클래스의 객체를 가리키는 가가각의 reference는 강한참조이다.
//// 최소한 하나의 강한참조가 있는한 이 객체의 메모리는 해제되지 않을 것이며 객체에 대한 강한참조가 존재하지 않는다면
//// 이는 메모리에서 해제된다.
//
//class ViewController: UIViewController {
//
//    var testClass: TestClass? = TestClass()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // testClass는 TestClass의 객체에 대한 강한 참조를 갖고 있다.
//        // 참조를 nil로 할당한다면 그 강한 참조는 사라지고 그로인해 TestClass의 객체의 메모리는 해제된다.
//        testClass = nil
//
//        // [출력]
//        // init
//        // deinit
//    }
//
//}
//
//class TestClass {
//
//    init() {
//        print("init")
//    }
//
//    deinit {
//        print("deinit")
//    }
//
//}

