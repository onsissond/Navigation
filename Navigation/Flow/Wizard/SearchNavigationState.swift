//
//  SearchNavigationState.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

typealias SearchNavigationAction = NavigationAction<SearchNavigationState.Step>
typealias SearchNavigationStore = Store<SearchNavigationState, SearchNavigationAction, Void>

struct SearchNavigationState: NavigationState {
    enum Step: Int, Equatable {
        case idle
        case search
        case details
    }

    var previousStep: Step = .idle
    var currentStep: Step = .idle {
        didSet {
            print("#Search# currentStep \(currentStep) ")
        }
    }
    var transaction: Transaction<Step>?
}
