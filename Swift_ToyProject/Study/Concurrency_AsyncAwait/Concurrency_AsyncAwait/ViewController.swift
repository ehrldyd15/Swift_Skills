//
//  ViewController.swift
//  Concurrency_AsyncAwait
//
//  Created by Do Kiyong on 2022/12/01.
//

import UIKit

// [4단계]
// [AsyncStream]
// 3단계의 handler 부분을 AsyncStream을 이용하여 for await in loop로 변환한다.
// http://minsone.github.io/swift-concurrency-convert-delegate-to-asyncawait sequence, asyncSequence, asyncstream을 공부하고 다시 온다.

// 참고자료
// 1. https://zeddios.tistory.com/1340 [Sequence]
// 2. https://zeddios.tistory.com/1339 [AsyncSequence]
// 3. https://zeddios.tistory.com/1341 [AsyncStream]

enum ViewAction {
    case tapped
    case refresh
}

protocol ViewActionListener: AnyObject {
    func send(action: ViewAction)
}

class ViewController: UIViewController {
    
    final class Adapter: ViewActionListener {
        var handler: ((ViewAction) -> Void)?
        
        func send(action: ViewAction) {
            handler?(action)
        }
    }
    
    let testView = SomeView()
    let adapter = Adapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testView.listener = adapter

        Task { @MainActor [weak self] in
            guard let self = self else { return }
            
            for await action in self.viewActionEvents() {
                switch action {
                case .tapped:
                    print("tapped")
                case .refresh:
                    print("refresh")
                }
            }
        }

        testView.tapped()

        testView.requestRefresh()
        
    }
    
    func viewActionEvents() -> AsyncStream<ViewAction> {
        let actions = AsyncStream(ViewAction.self) { [weak self] continuation in
            self?.adapter.handler = { action in
                continuation.yield(action)
            }
        }
        
        return actions
    }

}

class SomeView {
    weak var listener: ViewActionListener?
    
    init() {
        
    }
    
    func tapped() {
        listener?.send(action: .tapped)
    }
    
    func requestRefresh() {
        listener?.send(action: .refresh)
    }
}


// [3단계]
// [Concurrency]
// 2단계에서 Delegate 패턴으로 비동기로 Action을 받는 코드.
// 즉, Delegate 패턴으로 작성된 코드를 Concurrency 형태로 변환할 수 있다.
// 기존에 작성된 코드는 쉽게 바꿀 수 없지만 Action을 받아서 처리하는 곳은 Concurrency 형태로 변환할 수 있다.
// 먼저 ViewActionListener를 준수하는 ViewAdapter 클래스를 선언하며 이 클래스는 Delegate를 Closure로 바꿔주는 역할을 한다.

//enum ViewAction {
//    case tapped
//    case refresh
//}
//
//protocol ViewActionListener: AnyObject {
//    func send(action: ViewAction)
//}
//
//class ViewController: UIViewController {
//
//    final class Adapter: ViewActionListener {
//        var handler: ((ViewAction) -> Void)?
//
//        func send(action: ViewAction) {
//            handler?(action)
//        }
//    }
//
//    let testView = SomeView()
//    let adapter = Adapter()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        testView.listener = adapter
//
//        adapter.handler = { action in
//            switch action {
//            case .tapped:
//                print("tapped")
//            case .refresh:
//                print("refresh")
//            }
//        }
//
//        testView.tapped()
//
//        testView.requestRefresh()
//
//    }
//
//}
//
//class SomeView {
//    weak var listener: ViewActionListener?
//
//    init() {
//
//    }
//
//    func tapped() {
//        listener?.send(action: .tapped)
//    }
//
//    func requestRefresh() {
//        listener?.send(action: .refresh)
//    }
//}


// [2단계]
// 아래의 [Delegate 패턴]에서 함수가 많아진 것을 볼 수 있다.
// 그 함수들을 모아서 enum을 통해 하나로 합쳐보자

//enum ViewAction {
//    case tapped
//    case refresh
//}
//
//protocol ViewActionListener: AnyObject {
//    func send(action: ViewAction)
//}
//
//class ViewController: UIViewController, ViewActionListener {
//
//    let testView = SomeView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        testView.listener = self
//
//        testView.tapped()
//
//        testView.requestRefresh()
//
//    }
//
//    func send(action: ViewAction) {
//        switch action {
//        case .tapped:
//            print("tapped")
//        case .refresh:
//            print("refresh")
//        }
//    }
//
//}
//
//class SomeView {
//    weak var listener: ViewActionListener?
//
//    init() {
//
//    }
//
//    func tapped() {
//        listener?.send(action: .tapped)
//    }
//
//    func requestRefresh() {
//        listener?.send(action: .refresh)
//    }
//}


// [1단계]
// [Delegate 패턴]
// 일반적인 Delegate 패턴으로 View에서 수행된 액션을 ViewController에게 전달한다.
// 그러면 ViewController에서 이를 처리하는 코드를 작성한다.
// ViewController는 ViewActionListener를 준수해야하며, 이를 구현해야 한다.

//protocol ViewActionListener: AnyObject {
//    func tapped()
//    func refresh()
//}
//
//class ViewController: UIViewController, ViewActionListener {
//
//    let testView = SomeView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        testView.listener = self
//
//        testView.tapped()
//
//        testView.requestRefresh()
//
//    }
//
//    func tapped() {
//        print("tapped")
//    }
//
//    func refresh() {
//        print("refresh")
//    }
//
//}
//
//class SomeView {
//    weak var listener: ViewActionListener?
//
//    init() {
//
//    }
//
//    func tapped() {
//        listener?.tapped()
//    }
//
//    func requestRefresh() {
//        listener?.refresh()
//    }
//}
