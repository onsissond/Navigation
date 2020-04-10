//
// Copyright © 2019 LLC "Globus Media". All rights reserved.
//

import RxSwift
import RxCocoa

public final class Store<Value, Action, Environment> {
    private let _reducer: Reducer<Value, Action, Environment>
    public private(set) var environment: Environment
    private let _value: BehaviorRelay<Value>
    public var value: Value {
        get { _value.value }
        set { _value.accept(newValue) }
    }
    public var rxValue: Observable<Value> {
        return _value.share(replay: 1, scope: .whileConnected)
    }
    private let _bag = DisposeBag()

    public init(initialValue: Value,
                reducer: @escaping Reducer<Value, Action, Environment>,
                environment: Environment) {
        self._reducer = reducer
        self._value = BehaviorRelay<Value>(value: initialValue)
        self.environment = environment
    }

    public func send(_ action: Action) {
        let effects = self._reducer(&self.value, action)
        effects.forEach {
            $0.runReader(environment)
                .subscribe(onNext: self.send)
                .disposed(by: _bag)
        }
    }

    public func view<LocalValue, LocalAction, LocalEnvironment>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action,
        environment toLocalEnvironment: @escaping (Environment) -> LocalEnvironment
    ) -> Store<LocalValue, LocalAction, LocalEnvironment> {
        let localStore = Store<LocalValue, LocalAction, LocalEnvironment>(
            initialValue: toLocalValue(self.value),
            reducer: { localValue, localAction in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value)
                return []
        },
            environment: toLocalEnvironment(self.environment)
        )
        _value
            .map(toLocalValue)
            .bind(onNext: { [weak localStore] in localStore?.value = $0 })
            .disposed(by: _bag)
        return localStore
    }

    public func view<LocalValue, LocalAction>(
        value toLocalValue: @escaping (Value) -> LocalValue,
        action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction, Void> {
        let localStore = Store<LocalValue, LocalAction, Void>(
            initialValue: toLocalValue(self.value),
            reducer: { localValue, localAction in
                self.send(toGlobalAction(localAction))
                localValue = toLocalValue(self.value)
                return []
        },
            environment: ()
        )
        _value
            .map(toLocalValue)
            .bind(onNext: { [weak localStore] in localStore?.value = $0 })
            .disposed(by: _bag)
        return localStore
    }

    public func optionalize() -> Store<Value?, Action, Environment> {
        return self.view(value: Optional.some, action: { $0 }, environment: { $0 })
    }

    #if DEBUG
    // swiftlint:disable identifier_name
    var _onDeinit: (() -> Void)?
    deinit { _onDeinit?() }
    // swiftlint:enable identifier_name
    #endif
}
