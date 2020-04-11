//
// Copyright © 2020 LLC "Globus Media". All rights reserved.
//

import Prelude
import CasePaths
import Overture

typealias TabBarNavigationStore = Store<TabBarNavigationState, TabBarNavigationAction, Void>

struct TabBarNavigationState: NavigationState {
    var search: SearchNavigationState
    var profile: ProfileNavigationState

    enum Step: Int, Equatable {
        case search
        case profile
    }

    var previousStep: Step = .search
    var currentStep: Step = .search {
        didSet {
            print("#TabBar# Current step \(currentStep)")
        }
    }
    var transaction: Transaction<Step>?
}

enum TabBarNavigationAction {
    case search(SearchNavigationAction)
    case profile(ProfileNavigationAction)
    case tabBar(NavigationAction<TabBarNavigationState.Step>)
}

var tabBarNavigationReducer: Reducer<TabBarNavigationState, TabBarNavigationAction, Void> =
    pullback(
        navigationReducer,
        value: \.self,
        action: /TabBarNavigationAction.tabBar
) <> pullback(
        navigationReducer,
        value: \TabBarNavigationState.search,
        action: /TabBarNavigationAction.search
) <> pullback(
        navigationReducer,
        value: \TabBarNavigationState.profile,
        action: /TabBarNavigationAction.profile
)
