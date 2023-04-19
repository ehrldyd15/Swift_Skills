//
//  ViewController.swift
//  CombineTutorial
//
//  Created by Do Kiyong on 2023/04/18.
//

// 참고자료
// https://zeddios.tistory.com/925

import UIKit
import Combine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        publisherAndSubscriber()
        subject()
        scheduler()
        anyCancellable()
        
    }
    
    // MARK: ✅ 1. Publisher & Subscriber
    // publisher의 값을 subscribe하는 방법?이 3가지라고 할 수 있다.
    // 1-1. subscribe 메소드 사용
    // 1-2. sink 사용
    // 1-3. assign(to: on:) 사용
    func publisherAndSubscriber() {
        let publisher = ["A", "B", "C", "D"].publisher
        
        // MARK: 1-1. subscribe
        // subscribe는 프로토콜을 따로 구현해줘야 하기에 귀찮으니까 애플에서는 sink를 만들었다.. 이것만 쓰면될듯??
        publisher.subscribe(TestSubscriber())
        
        // MARK: 1-2. sink
        // sink 메소드는 subscriber를 만들고,
        // subscriber를 리턴하기 전에 즉시 unlimited number of values를 요청한다.
        // sink가 subscriber의 인스턴스를 만들어준다.
        
//        let subscriber = publisher.sink { (value) in
//              print(value) // "A" "B" "C" "D"
//        }
        
        // receiveCompletion도 있는 인터페이스도 있다.
        // 만약 Error를 낼 수 있으면 receiveCompletion을 가지는 메소드밖에 호출 못한다.
        let subscriber = publisher.sink(receiveCompletion: { (result) in
             switch result {
                 case .finished:
                      print("finished") // 2. "finished"
                 case .failure(let error):
                      print(error.localizedDescription)
              }
        }, receiveValue: { (value) in
              print(value) // 1. "A" "B" "C" "D"
        })
        
        // MARK: 1-3. assign(to: on:)
        // assign(to:on:)는 새로운 값을 keyPath에 따라 주어진 인스턴스의 property에 할당한다.
        // 역시 sink가 편한듯...
        // assign은 publisher로 부터 받은 값을 주어진 instance의 property에 할당한다.
        // 주어지는 값이 무조건 있어야하기 때문에 sink와는 다르게 publisher의 Failure 타입이 Never일때만 사용 가능하다.
        // 이것이 편한 이유는 sink와 마찬가지로 assign을 사용할 때 그 귀찮은 protocol들을 모두 구현한 자체 subscriber가 같이 제공되고 연결되기 때문이다.
        let object = SomeObject()
        
        // to 는 값이 할당될 property 자리고 on은 해당 property를 갖는 instance의 자리 같은데… 도대체 to 안에 \.는 왜 들어갈까?
        // 처음에 assign은 새로운 값을 keyPath에 따라 주어진 인스턴스의 property에 할당하는 것이라고 했다.
        // \.value는 keyPath이다.
        // \.가 바로 object의 property를 특정하기 위해 사용하는 Key-Path Expression이다.

        // 간단히 설명하자면 key-path 표현을 통해 type의 property를 나타낼 수 있다.
        // \typeName.path 가 기본형이지만 타입 추론이 가능할때는 typeName을 생략할 수 있다.
        // \SomeObject.value 대신 \.value 를 사용한 것이다.
        let subscriber2 = publisher.assign(to: \.value, on: object)
    }
    
    // MARK: ✅ 2. Subject
    // Subject는 외부 발신자(outside callers)가 element를 publish할 수 있는 방법을 제공하는 publisher
    // ㅇㅇ 그냥 Publisher, 그도 그럴것이 Publisher를 채택하고있다.
    // Subject 프로토콜의 concrete implementation이 2개가 존재하는데
    // 2-1. CurrentValueSubject
    // 2-2. PassthroughSubject
    func subject() {
        let currentValueSubject = CurrentValueSubject<String, Never>("ABC")
        let passthroughSubject = PassthroughSubject<String, Never>()
        
        // MARK: 2-1. CurrentValueSubject
        // PassthroughSubject와 달리 CurrentValueSubject는 가장 최근에 publish된 element의 버퍼를 유지
        // CurrentValueSubject에서 send를 호출하면, 현재 값도 업데이트 되므로, 값을 직접 업데이트 하는 것과 같다.
        let subscriber = currentValueSubject.sink(receiveValue: {
            print($0)
        })
        
        currentValueSubject.value = "안녕"
        currentValueSubject.send("하이")
        
        // MARK: 2-2. PassthroughSubject
        // downstream subscribers에게 element를 broadcasts하는 subject
        // CurrentValueSubject와 달리, PassthroughSubject에는 가장 최근에 publish된 element의 초기값 또는 버퍼가 없다.
        // PassthroughSubject는 subscribers가 없거나 현재 demand가 0이면 value를 삭제(drop)한다.
        let subscriber2 = passthroughSubject.sink(receiveValue: {
                  print($0)
        })
        
        passthroughSubject.send("BCD")
        passthroughSubject.send("EFG")
        
        // MARK: 추가사항
        // Subject는 send(_:)라는 메소드를 통해 값을 스트림에 "주입"할 수 있는 Publisher이다.
        // send(input: )은 위에서 본대로 ...
        
        // send(completion:)은 subscriber에게 completion signal을 보내는 메소드
        let passthroughSubject2 = PassthroughSubject<String, Error>() // Never는 error가 발생 할 일이 없다는 거니까 Never로 지정하면 .failure를 호출할 수 없다.

        let subscriber3 = passthroughSubject2.sink(receiveCompletion: { (result) in
            switch result {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, receiveValue: { (value) in
            print(value)
        })
        
        passthroughSubject2.send("123")
        passthroughSubject2.send("456")
        
//        passthroughSubject2.send(completion: .failure(TestError.unknown))
        passthroughSubject2.send(completion: .finished)
        
        passthroughSubject.send("끝나서 출력 안됨")
    }
    
    // MARK: ✅ 3. Scheduler
    // Scheduler를 지정하지 않더라도 Combine은 기본 Scheduler를 제공한다.
    // Scheduler는 element가 생성된 스레드와 동일한 스레드를 사용합니다.
    // Scheduler를 명시적으로 지정해주는 방법은 2가지다.
    // 1. receive(on: )
    // 2. subscribe(on:)
    func scheduler() {
        // MARK: 3-1. receive(on: )
        // receive(on: )은 publisher로 부터 element를 수신할 scheduler를 지정하는 역할을 한다.
        // 정확히 말하면 downstream의 실행 컨텍스트를 변경하는 역할이다.
        // Scheduler는 프로토이다.
        // receive(on: )이나 subscribe(on:)은 파라미터 타입으로 이 Scheduler타입을 받는다.
        // 그리고 DispatchQueue, OperationQueue, RunLoop, ImmediateScheduler 얘네는 전부 Scheduler를 채택하고 있다.
        // 물론 iOS 13이상 부터 그러니까.. 암거나 막 넣어도 됨
//        let publisher = ["가나다"].publisher
//        publisher
//            .map { _ in print(Thread.isMainThread) } // true
//            .receive(on: DispatchQueue.global())
//            .map { print(Thread.isMainThread) } // false
//            .sink { print(Thread.isMainThread) } // false
        
        // MARK: 3-2. subscribe(on: )
        // subscribe(on:)은 subscribe, cancel, request operation을 수행 할 scheduler를 지정하는 역할을 한다.
        // upstream의 실행 컨텍스트를 변경
        
        let publisher2 = CurrentValueSubject<String, Never>("ABCDEFG")
        
        publisher2
            .subscribe(on: DispatchQueue.global())
            .sink { _ in print("Sink: \(Thread.isMainThread)") } // false
        // subscribe(on:)은 upstream에만 영향 준다고 했는데 결과 값이 false가 됐다....
        // 그 이유는 subscribe(on:)은 지정된 global queue에서 upstream을 subscribe하기 떄문
        // 간단히 말해서 구독 자체가 global queue에서 일어났고, output downstream이 동일한 queue에서 전달되므로 sink에서도 false를 리턴하게 된다.
        // 위에서도 언급했듯이 "Scheduler는 element가 생성된 스레드와 동일한 스레드를 사용한다."
        // 그래서 subscribe(on: )의 위치가 상관이 없을것 같다.
        // receive(on: )으로 명시적으로 downstream의 스케쥴러를 변경하지 않는 이상, subscribe 자체가 일어나는 스케쥴러를 지정한다.
    }
    
    // MARK: ✅ 4. AnyCancellable
    // AnyCancellable은 클래스다.
    // AnyCancellable은 취소 되었을 때, 제공된 closure를 실행하는 type-erasing cancellable object다.
    // Subscriber 구현에서는 이 타입을 사용해서 caller가 publisher를 취소할 수 있지만,
    // Subscription 객체를 사용하여 item을 요청할 수 없는 "cancellation token"을 제공할 수 있다.
    // AnyCancellable 인스턴스는 deinitialized 될 때 자동으로 cancel()을 호출한다.
    func anyCancellable() {
        // MARK: 4-1. cancel()
        let subject = PassthroughSubject<Int, Never>()
        
        let subscriber = subject.sink(receiveValue: { value in
             print(value)
        })
        
        subscriber.cancel()
        subject.send(1) // cancel()이 호출됐기 때문에 nil이 되어 데이터 주입이 차단된다.
        
        // MARK: 4-2. store(in: )
        // 간단히 말해 Cancellable instance를 저장한다고 보면 된다.
        // store메소드안에 보면 파라미터의 타입이 Set<AnyCancellable>인걸 볼 수 있는데
        // Set<AnyCancellable>을 만들어주고, 그걸 그냥 store에 넘기면 된다.
        var bag = Set<AnyCancellable>()
        
        let subject2 = PassthroughSubject<Int, Never>()
        
        subject2
            .sink(receiveValue: { value in
                print(value)
            })
            .store(in: &bag)
        
        // MARK: 4-3. handleEvents
        // custom Subscriber를 만들어 직접 취소되었을떄 클로저를 구현할 수있지만 귀찮기 때문에 애플에서 제공해주는 handleEvents를 활용해보자
        // 정의는 "publisher 이벤트가 발생 할 때 지정한 closure를 수행한다."
        let subject3 = PassthroughSubject<String, Error>()
        
        let subscriber2 = subject3.handleEvents(receiveSubscription: { (subscription) in
            print("Receive Subscription") // 2
        }, receiveOutput: { output in
            print("Receive Output : \(output)") // 3
        }, receiveCompletion: { (completion) in
            print("Receive Completion")
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveCancel: {
            print("Receive Cancel")
        }, receiveRequest: { demand in
            print("Receive Request: \(demand)") // 1
        }).sink(receiveCompletion: { (completion) in // 일단 sink를 써야 send등이 작동한다.
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { (value) in
            print("Receive Value in sink : \(value)") // 4
        })
        
        subject3.send("ABC")
        subscriber2.cancel()
    }
}

class TestSubscriber: Subscriber {
    // Subscriber는 프로토콜이다 따라서 아래와 같이 요구하는 프로퍼티와 메소드가 있다.
    
    typealias Input = String
    typealias Failure = Never
    
    // 1) subscriber에게 publisher를 성공적으로 구독했음을 알리고 item을 요청할 수 있음
    func receive(subscription: Subscription) {
        print("구독 시작~")
        subscription.request(.unlimited)
        // unlimited(무제한)
        // max(최대 개수 제한)
        // none(no elements. max(0)과 같음)
    }
    
    // 2) subscriber에게 publisher가 element를 생성했음을 알림
    func receive(_ input: String) -> Subscribers.Demand {
        print("\(input)")

        return .none
    }
    
    // 3) subscriber에게 publisher가 정상적으로 또는 오류로 publish를 완료했음을 알림
    func receive(completion: Subscribers.Completion<Never>) {
        print("완료", completion)
    }
    
}

class SomeObject {
    // 새로 받은 값을 object의 value 에 할당하기 때문에 value의 값이 바뀌면서 didSet 안에 있는 print 함수가 실행되고, 콘솔에는 다음과 같이 출력
    // A
    // B
    // C
    // D
    var value: String = "" {
        didSet {
            print(value)
        }
    }
    
}

enum TestError: Error {
    case unknown
}
