//
// Copyright © 2019 LLC "Globus Media". All rights reserved.
//

#if os(iOS)
import Reader
import RxSwift
import RxFeedback

extension Observable where E == Any {
    public static func system<State, Event, Environment>(
        initialState: State,
        reduce: @escaping (inout State, Event) -> [Reader<Environment, Effect<Event>>],
        scheduler: ImmediateSchedulerType,
        environment: Environment,
        feedback: [Feedback<State, Event>]
    ) -> Observable<State> {
        // swiftlint:disable nesting
        typealias AdapterState = (state: State, effects: Set<_Request<Reader<Environment, Effect<Event>>>>)
        typealias AdapterEvent = _Event<Event, Reader<Environment, Effect<Event>>>
        // swiftlint:enable nesting
        let adapterReducer: (AdapterState, AdapterEvent) -> AdapterState = { adapterState, adapterEvent in
            var (state, effects) = adapterState
            switch adapterEvent {
            case let .event(event):
                let newEffects = reduce(&state, event)
                    .map { _Request(effect: $0) }
                return (state, effects.union(newEffects))
            case let .completedEffect(effect):
                effects.remove(effect)
                return (state, effects)
            }
        }
        let adapterFeedback = feedback.map { f -> Feedback<AdapterState, AdapterEvent> in
            return { context in
                return f(ObservableSchedulerContext<State>(source: context.map { $0.state },
                                                           scheduler: context.scheduler))
                    .map(AdapterEvent.event)
            }
        }
        let effects: [(ObservableSchedulerContext<AdapterState>) -> Observable<AdapterEvent>] = [
            react(requests: { adapterState -> Set<_Request<Reader<Environment, Effect<Event>>>> in
                return adapterState.effects
            }, effects: { effect -> Observable<AdapterEvent> in
                return .create { observer -> Disposable in
                    effect.effect
                        .runReader(environment)
                        .subscribe { event in
                            switch event {
                            case let .next(a):
                                observer.onNext(.event(a))
                                observer.onNext(.completedEffect(effect))
                            case .completed:
                                observer.onCompleted()
                            }
                    }
                }
            })
        ]
        return system(initialState: AdapterState(initialState, []),
                      reduce: adapterReducer,
                      scheduler: scheduler,
                      feedback: adapterFeedback + effects)
            .map { $0.state }
    }
}

private struct _Request<Effect> {
    private let _id = UUID()
    let effect: Effect
}
extension _Request: Equatable {
    static func == (lhs: _Request<Effect>, rhs: _Request<Effect>) -> Bool {
        return lhs._id == rhs._id
    }
}
extension _Request: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
}

private enum _Event<Event, Effect> { case event(Event), completedEffect(_Request<Effect>) }
#endif
