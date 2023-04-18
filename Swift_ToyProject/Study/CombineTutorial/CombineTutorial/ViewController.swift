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

    // MARK: Properties of Publisher & Subscriber
    let publisher = ["A", "B", "C", "D"].publisher
    
    // MARK: Properties of Subject
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publisherAndSubscriber()

    }
    
    // MARK: 1. Publisher & Subscriber
    // publisher의 값을 subscribe하는 방법?이 3가지라고 할 수 있다.
    // subscribe 메소드 사용
    // sink 사용
    // assign(to: on:) 사용
    func publisherAndSubscriber() {
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
    
    // MARK: 2. Subject
    

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
