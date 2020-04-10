//
// Copyright © 2019 LLC "Globus Media". All rights reserved.
//

import Prelude
import Reader
import CasePaths

public typealias Reducer<Value, Action, Environment> = (inout Value, Action) -> [Reader<Environment, Effect<Action>>]

public func <> <Value, Action, Environment>(
    lhs: @escaping Reducer<Value, Action, Environment>,
    rhs: @escaping Reducer<Value, Action, Environment>
) -> Reducer<Value, Action, Environment> {
    return combine(lhs, rhs)
}

public func combine<Value, Action, Environment>(
    _ reducers: Reducer<Value, Action, Environment>...
) -> Reducer<Value, Action, Environment> {
    return { value, action in reducers.flatMap { $0(&value, action) } }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, LocalEnvironment, GlobalEnvironment>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction, LocalEnvironment>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: CasePath<GlobalAction, LocalAction>,
    environment: KeyPath<GlobalEnvironment, LocalEnvironment>
) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
    return { globalValue, globalAction in
        guard let localAction = action.extract(from: globalAction) else { return [] }
        let localEffects = reducer(&globalValue[keyPath: value], localAction)

        return localEffects.map { localEffect in
            Reader { globalEnvironment in
                localEffect.runReader(globalEnvironment[keyPath: environment])
                    .map(action.embed)
            }
        }
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction, GlobalEnvironment>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction, Void>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: CasePath<GlobalAction, LocalAction>
) -> Reducer<GlobalValue, GlobalAction, GlobalEnvironment> {
    return { globalValue, globalAction  in
        guard let localAction = action.extract(from: globalAction) else { return [] }
        _ = reducer(&globalValue[keyPath: value], localAction)
        return []
    }
}

public func optionalize<Value, Action, Environment>(
    _ reducer: @escaping Reducer<Value, Action, Environment>
) -> Reducer<Value?, Action, Environment> {
    return { optionalState, action in
        guard var state = optionalState else { return [] }
        let effects = reducer(&state, action)
        optionalState = state
        return effects
    }
}

public func logging<Value, Action, Environment>(
    tag: String = "",
    _ reducer: @escaping Reducer<Value, Action, Environment>
) -> Reducer<Value, Action, Environment> {
    return { value, action in
        let effects = reducer(&value, action)
        let newValue = value
        return [pure(Effect { _ in
            debugPrint(tag, "Action: \(action)")
            debugPrint(tag, "Value:")
            debugPrint(tag, newValue)
            debugPrint(tag, "---")
        })] + effects
    }
}
