//
//  AppDelegate.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

import UIKit
import Overture

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var _window = UIWindow()
    private lazy var _sceneFactory = SceneFactory(
        store: _appStore.view(
            value: \AppState.navigationState,
            action: AppEvent.navigation
        )
    )
    private let _appStore = AppStore(
        initialValue: AppState(
            navigationState: AppNavigationState(
                onboarding: OnboardingNavigationState(),
                tabBar: TabBarNavigationState(
                    search: .init(),
                    profile: .init()
                )
        )),
        reducer: appStateReducer,
        environment: AppEnvironment()
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        _window.rootViewController = _sceneFactory.mainTabBarController
        _window.makeKeyAndVisible()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self._goToSettigns()
        }
        return true
    }

    private func _goToSettigns() {
        _appStore.send(.navigation(.tabBar(.tabBar(.execute(.select(.profile))))))
    }
}

