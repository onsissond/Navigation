//
// Copyright © 2020 LLC "Globus Media". All rights reserved.
//

struct OnboardingNavigationState: NavigationState {
    enum Step: Equatable {
        case idle
        case slide
    }

    var previousStep: Step = .idle
    var currentStep: Step = .idle
    var transaction: Transaction<Step>?
}
