//
//  SearchViewController.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

import UIKit

class SearchNavigationController: UINavigationController {
    private let _store: TabBarNavigationStore
    private var _sceneFactory: SceneFactory

    init(
        store: TabBarNavigationStore,
        sceneFactory: SceneFactory
    ) {
        _store = store
        _sceneFactory = sceneFactory
        super.init(
            rootViewController: _sceneFactory.makeSearchComponent()
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _store.send(.tabBar(.didAppear(.search)))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _store.send(.tabBar(.didDisappear(.search)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
