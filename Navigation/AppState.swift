//
//  AppState.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

import Prelude
import CasePaths

typealias AppStore = Store<AppState, AppEvent, AppEnvironment>

struct AppState {
    var navigationState: AppNavigationState
}

enum AppEvent {
    case navigation(AppNavigationAction)
}

struct AppEnvironment {
    var navigation: Void = Void()
}

var appStateReducer: Reducer<AppState, AppEvent, AppEnvironment> = { state, _ in
    []
}
    <> pullback(appNavigationReducer,
    value: \AppState.navigationState,
    action: /AppEvent.navigation,
    environment: \AppEnvironment.navigation)
