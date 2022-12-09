//
//  CounterVIewReactor.swift
//  ReactorKit_Tutorial
//
//  Created by Do Kiyong on 2022/12/09.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

class CounterViewReactor: Reactor {
    
    let initialState = State()
    
    // View로부터 받을 Action을 enum으로 정의
    enum Action {
        case increase
        case decrease
    }
    
    // View로부터 action을 받은 경우, 해야할 작업단위들을 enum으로 정의 (처리 단위)
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    // 현재 상태를 기록하고 있으며,
    // View에서 해당 정보를 사용하여 UI업데이트 및 Reactor에서 image를 얻어올때 page정보들을 저장
    struct State {
        var value = 0
        var isLoading = false
    }
    
    // Action이 들어온 경우, 어떤 처리를 할것인지 Mutation에서 정의한 작업 단위들을 사용하여 Observable로 방출
    // 해당 부분에서, RxSwift의 concat 연산자를 이용하여 비동기 처리가 유용
    // concat 연산자: 여러 Observable이 배열로 주어지면 순서대로 실행
    // 그 밖의 merge, combineLatest, withLatestFrom, zip은 https://ios-development.tistory.com/177 <--- 여기서 확인
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.increaseValue).delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        case .decrease:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.decreaseValue).delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(.setLoading(false))
            ])
        }
    }
    
    // 현재 상태(state)와 작업 단위(mutation)을 받아서, 최종 상태를 반환
    // mutate(action:) -> Observable<Mutation>이 실행된 후 바로 해당 메소드 실행
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        
        return newState
    }
    
}
