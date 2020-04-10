//
//  SceneFactory.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

import UIKit
import Prelude
import CasePaths

struct SceneFactory {

    private let _store: AppNavigationStore

    private lazy var _tabBarNavigationStore: TabBarNavigationStore =
        _store.view(
            value: ^\.tabBar,
            action: AppNavigationAction.tabBar
    )

    init(store: AppNavigationStore) {
        _store = store
    }

    lazy var mainTabBarController: UITabBarController =
        TabBarController(
            store: _tabBarNavigationStore,
            sceneFactory: self
    )

    func make(index: Int) -> UIViewController {
        let vc = ViewController()
        switch index {
        case 0:
            vc.render(text: "List screen", color: .brown)
        case 1:
            vc.render(text: "Settings screen", color: .gray)
        case 2:
            vc.render(text: "Details screen", color: .green)
        case 3:
            vc.render(text: "Passengers screen", color: .yellow)
        case 4:
            vc.render(text: "Notifications screen", color: .blue)
        default:
            break

        }
        return vc
    }

    mutating func makeSearchFlow() -> UINavigationController {
        SearchNavigationController(
            store: _tabBarNavigationStore,
            sceneFactory: self
        )
    }

    mutating func makeProfileFlow() -> UINavigationController {
        ProfileNavigationController(
            store: _tabBarNavigationStore,
            sceneFactory: self
        )
    }

    mutating func makeSearchComponent() -> UIViewController {
        let vc = SearchViewController(
            store: _tabBarNavigationStore.view(
                value: ^\.search,
                action: TabBarNavigationAction.search
            ),
            sceneFactory: self
        )
        vc.render(text: "Search screen", color: .red)
        return vc
    }

    mutating func makeProfileComponent() -> UIViewController {
        let vc = ProfileViewController(
            store: _tabBarNavigationStore.view(
                value: ^\.profile,
                action: TabBarNavigationAction.profile
            ),
            sceneFactory: self
        )
        vc.render(text: "Profile screen", color: .green)
        return vc
    }
}
