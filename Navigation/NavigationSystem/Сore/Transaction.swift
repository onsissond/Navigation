//
// Copyright © 2020 LLC "Globus Media". All rights reserved.
//

enum Transaction<Step: Equatable>: Equatable {
    case dismiss(Step)
    case present(Step)
    case push(Step)
    case select(Step)

    func opening(_ step: Step) -> Bool {
        switch self {
        case .present(let currentStep),
             .push(let currentStep):
            return currentStep == step
        case .dismiss, .select:
            return false
        }
    }

    func closing(_ step: Step) -> Bool {
        switch self {
        case .present, .push:
            return false
        case .dismiss(let currentStep),
             .select(let currentStep):
            return currentStep == step
        }
    }
}
