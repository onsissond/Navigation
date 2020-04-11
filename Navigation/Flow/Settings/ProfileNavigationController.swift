//
//  ProfileNavigationController.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    private let _store: TabBarNavigationStore
    private var _sceneFactory: SceneFactory

    init(
        store: TabBarNavigationStore,
        sceneFactory: SceneFactory
    ) {
        _store = store
        _sceneFactory = sceneFactory
        super.init(
            rootViewController: _sceneFactory.makeProfileComponent()
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _store.send(.tabBar(.didAppear(.profile)))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _store.send(.tabBar(.didDisappear(.profile)))
    }
}
