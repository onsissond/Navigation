//
// Copyright © 2020 LLC "Globus Media". All rights reserved.
//

import Reader
import Prelude
import CasePaths

protocol NavigationStep: Equatable {}

func navigationReducer<State: NavigationState>(
    state: inout State,
    action: NavigationAction<State.Step>
) -> [Reader<Void, Effect<NavigationAction<State.Step>>>] {
    switch action {
    case .didAppear(let step):
        if state.transaction?.opening(step) == true {
            break
        }
        state.stopTransition()
        state.previousStep = state.currentStep
        state.currentStep = step
    case .didDisappear(let step):
        if state.transaction?.closing(step) == true {
            break
        }
        state.stopTransition()
        if state.currentStep != step {
            state.currentStep = state.previousStep
        }
    case .execute(let transaction):
        state.startTransition(transaction)
    case .executed(let transaction):
        if transaction == state.transaction {
            state.transaction = nil
        }
    }
    return []
}


