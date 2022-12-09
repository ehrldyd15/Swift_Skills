//
//  CounterViewController.swift
//  ReactorKit_Tutorial
//
//  Created by Do Kiyong on 2022/12/09.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import ReactorKit

// storyboard 이용 시 StoryboardView 구현
class CounterViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    // 인터렉션을 Reactor에서 정의한 값으로 매핑
    // 뷰와 리엑터 사이의 액션 스트림과 상태 스트림을 바인드하기 위한 메서드
    func bind(reactor: CounterViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // View에서 Reactor로 이벤트 방출
    private func bindAction(_ reactor: CounterViewReactor) {
        increaseButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    // Reactor에서 바뀐 state들을 View에서 구독
    private func bindState(_ reactor: CounterViewReactor) {
        reactor.state
            .map { String($0.value) }
            .distinctUntilChanged()
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
}
