//
// Copyright © 2020 LLC "Globus Media". All rights reserved.
//

typealias ProfileNavigationAction = NavigationAction<ProfileNavigationState.Step>
typealias ProfileNavigationStore = Store<ProfileNavigationState, ProfileNavigationAction, Void>

struct ProfileNavigationState: NavigationState {
    enum Step: Equatable {
        case idle
        case profile
        case notifications
    }

    var previousStep: Step = .idle
    var currentStep: Step = .idle
    var transaction: Transaction<Step>?
}
