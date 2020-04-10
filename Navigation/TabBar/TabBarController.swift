//
//  TabBarController.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

import UIKit
import RxSwift
import Prelude
import CasePaths
import Overture
import RxOptional

class TabBarController: UITabBarController {

    private var _sceneFactory: SceneFactory
    private let _store: TabBarNavigationStore
    private let _disposeBag = DisposeBag()

    init(
        store: TabBarNavigationStore,
        sceneFactory: SceneFactory
    ) {
        _store = store
        _sceneFactory = sceneFactory
        super.init(nibName: nil, bundle: nil)
        _setViewControllers()
        _setupSubscribtion()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupSubscribtion() {
        _store.rxValue
            .map { $0.transaction }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] transaction in
                guard case let .select(page) = transaction else { return }
                self?.selectedIndex = page.rawValue
            })
            .disposed(by: _disposeBag)
    }

    private func _setViewControllers() {
        setViewControllers(
            [
                _sceneFactory.makeSearchFlow(),
                _sceneFactory.makeProfileFlow()
            ],
            animated: true
        )
    }
}
