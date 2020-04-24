//
//  CategoricalDescriptor.swift
//  Xper
//
//  Created by Thomas Burguiere on 10/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

open class CategoricalDescriptor : Descriptor {
    open var states : [State] = [State]()
    
    deinit{
        for r in resources{
            r.object = nil
        }
    }

    public func addState(state: State) {
        state.descriptor = self
        self.states.append(state)
    }

    public func addStates(states: Array<State>) {
        for state in states {
            self.addState(state: state)
        }
    }

    public func setStates(states: Array<State>) {
        self.states.removeAll()
        self.addStates(states: states)
    }

    public func getStates() -> Array<State> {
        return self.states
    }
    
    override open var description: String {
        return "\(String(describing: name)) - states: \(states)"
    }
}
