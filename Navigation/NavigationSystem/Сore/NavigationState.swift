//
// Copyright © 2020 LLC "Globus Media". All rights reserved.
//

protocol NavigationState: Equatable {
    associatedtype Step: Equatable

    var transaction: Transaction<Step>? { get set }
    var previousStep: Step { get set }
    var currentStep: Step { get set }
    mutating func stopTransition()
    mutating func startTransition(
        _ transaction: Transaction<Step>
    )
}

extension NavigationState {
    mutating func stopTransition() {
        self.transaction = nil
    }

    mutating func startTransition(
        _ transaction: Transaction<Step>
    ) {
        self.transaction = transaction
    }
}
