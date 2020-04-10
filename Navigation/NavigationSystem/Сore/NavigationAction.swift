//
// Copyright © 2020 LLC "Globus Media". All rights reserved.
//

enum NavigationAction<Step: Equatable>: Equatable {
    case didAppear(Step)
    case didDisappear(Step)
    case execute(Transaction<Step>)
    case executed(Transaction<Step>)
}
