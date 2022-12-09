//
//  SceneDelegate.swift
//  ReactorKit_Tutorial
//
//  Created by Do Kiyong on 2022/12/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // 뷰를 정의하기 위해서, 존재하는 클래스에 View 프로토콜을 컨펌시키자.
        // 그러면 reactor라는 프로퍼티를 자동으로 가질 수 있다.
        // 이 프로퍼티는 일반적으로 view의 외부에 설정된다. (뷰 외부에서 reator 주입시키는 것이 일반적)
        let counterVC = window?.rootViewController as? CounterViewController
        let counterViewReactor = CounterViewReactor()
        
        counterVC?.reactor = counterViewReactor
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }

}

