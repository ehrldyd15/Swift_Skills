//
//  ViewController.swift
//  LazyVariables
//
//  Created by Do Kiyong on 2022/12/13.
//  [참고자료]
//  https://baked-corn.tistory.com/30?category=718234
//  https://baked-corn.tistory.com/45

import UIKit

// [6단계]
// [Common Scenarios for Retain Cycles : Closures]
// Closure는 Retain Cycle이 빈번히 일어나는 시나리오 중 하나이다.

class ViewController: UIViewController {

    var testClass: TestClass? = TestClass()

    override func viewDidLoad() {
        super.viewDidLoad()

        testClass = nil

        // TestClass의 객체의 내부에서 Closure로, Closure에서 TestClass객체로 강한 참조를 하고 있기 때문에
        // TestClass 객체의 메모리가 해제되지 않는다.
        
        // [출력]
        // init
        
        // Closure 역시 Class와 마찬가지로 Reference Type 이기 때문에
        // ✅[weak self]✅를 capture해줌으로써 해결할 수 있다.
        // 이렇게 되면 TestClass Instance는 Closure를 강한참조, Closure는 TestClass Instance를 약한참조 하게된다.
        
        // [출력]
        // init
        // deinit
    }

}

class TestClass {
    
    var aBlock: (()->())? = nil

    let aConstant = 5
        
        init() {
            print("init")
            
            aBlock = { [weak self] in // ✅ [weak self]를 추가하여
                print(self?.aConstant)
            }
        }
    
        deinit {
            print("deinit")
        }

}


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

