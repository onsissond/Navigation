//
// Copyright © 2020 LLC "Globus Media". All rights reserved.
//

import CasePaths

typealias AppNavigationStore = Store<AppNavigationState, AppNavigationAction, Void>

struct AppNavigationState: NavigationState {
    var onboarding: OnboardingNavigationState
    var tabBar: TabBarNavigationState

    enum Step: Equatable {
        case onboarding
        case tabBar
    }

    var previousStep: Step = .tabBar
    var currentStep: Step = .tabBar
    var transaction: Transaction<Step>?
}

enum AppNavigationAction {
    case onboarding(NavigationAction<OnboardingNavigationState.Step>)
    case tabBar(TabBarNavigationAction)
}

var appNavigationReducer: Reducer<AppNavigationState, AppNavigationAction, Void> =
    pullback(
        tabBarNavigationReducer,
        value: \AppNavigationState.tabBar,
        action: /AppNavigationAction.tabBar
)


// Три задачи: стейт навигации приложения,
// программный переход (как запускать и останавливать)
// переход пользователя (актуальность стейта)


// TabBarController, NavigationController подписываются на стейт
// Контроллеры
// и реализуют программную навигацию
// Как создавать старые модули. Контроллеру нужна фабрика для VIPER модуля 
// Как закрыть несколько флоу
// Закрыть флоу открыть другое
