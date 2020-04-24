//
//  DescriptionElementState.swift
//  Xper
//
//  Created by Thomas Burguiere on 10/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

open class DescriptionElementState: Equatable, Hashable  {
    open var selectedStates: [State] = []
    open var quantitativeMeasure: QuantitativeMeasure?
    open var unknown: Bool = false
    open var contextualWeigh: Int = 3

    public init(){}

    public init(selectedStates: Array<State>) {
        self.selectedStates = selectedStates
    }

    public init(quantitativeMeasure: QuantitativeMeasure) {
        self.quantitativeMeasure = quantitativeMeasure
    }

    public var isDescribed: Bool {
        return selectedStates.isEmpty == false || quantitativeMeasure?.mean != nil
    }

    public static func ==(lhs: DescriptionElementState, rhs: DescriptionElementState) -> Bool {
        var sameQuantMeasure = false;
        if lhs.quantitativeMeasure == nil {
            if rhs.quantitativeMeasure != nil {
                return false
            }
            sameQuantMeasure = true
        } else {
            if rhs.quantitativeMeasure == nil {
                return false
            }
            sameQuantMeasure = lhs.quantitativeMeasure! == rhs.quantitativeMeasure!
        }

        return lhs.selectedStates == rhs.selectedStates && sameQuantMeasure
    }

    public var hashValue: Int {
        let stateHasValue = selectedStates.reduce(into: 0) { (result: inout Int, state: State) in
            result ^= state.hashValue
        }
        var qmHashValue = 0
        if let qm = quantitativeMeasure {
            qmHashValue = qm.hashValue
        }
        return stateHasValue ^ qmHashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        for state in selectedStates {
            hasher.combine(state)
        }
        
        if let qm = quantitativeMeasure {
            hasher.combine(qm)
        } else {
            hasher.combine(0)
        }
    }
}
