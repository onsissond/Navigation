//
//  SearchViewController.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: ViewController {
    private let _store: SearchNavigationStore
    private let _sceneFactory: SceneFactory
    private let _disposeBag = DisposeBag()

    init(
        store: SearchNavigationStore,
        sceneFactory: SceneFactory
    ) {
        _store = store
        _sceneFactory = sceneFactory
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.navigationController?.pushViewController(
                    self._sceneFactory.make(index: 0),
                    animated: true
                )
            })
            .disposed(by: _disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _store.send(.didAppear(.search))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _store.send(.didDisappear(.search))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

