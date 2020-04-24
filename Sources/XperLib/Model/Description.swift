//
//  Description.swift
//  Xper
//
//  Created by Thomas Burguiere on 10/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

open class Description : CustomStringConvertible, Hashable {
    open var descriptionElements : [Descriptor : DescriptionElementState]
    
    public init() {
        descriptionElements = [Descriptor: DescriptionElementState]()
    }
    
    open var description: String{
        var string =  ""
        for (descriptor, des) in descriptionElements {
            string += "\(String(describing: descriptor.name)): \(des.selectedStates)\n"
        }
        return string
    }
    
    open func removeState(_ state: State, forDescriptor descriptor: Descriptor) {
        let selectedStates = descriptionElements[descriptor]?.selectedStates
        if let indexOfStateToDelete = selectedStates!.firstIndex(of: state) {
            descriptionElements[descriptor]?.selectedStates.remove(at: indexOfStateToDelete)
        }
    }
    
    open func isDescriptionComplete() -> Bool {
        for (descriptor, descriptionElementState) in descriptionElements {
            if(!descriptionElementState.unknown) {
                if(type(of: descriptor) === CategoricalDescriptor.self){
                    if(descriptionElementState.selectedStates.count == 0){
                        return false
                    }
                } else if (type(of: descriptor) === QuantitativeDescriptor.self) {
                    if(descriptionElementState.quantitativeMeasure == nil ||
                        descriptionElementState.quantitativeMeasure!.computedMin == nil ||
                        descriptionElementState.quantitativeMeasure!.computedMax == nil) {
                        return false
                    }
                }
            }
        }
        return true
    }

   
    public func hash(into hasher: inout Hasher) {
        for (key, value) in descriptionElements {
            hasher.combine(key)
            hasher.combine(value)
        }
    }

    public static func ==(lhs: Description, rhs: Description) -> Bool {
        let lhsDescriptionsElements: Dictionary<Descriptor, DescriptionElementState> = lhs.descriptionElements
        let rhsDescriptionsElements: Dictionary<Descriptor, DescriptionElementState> = rhs.descriptionElements

        if (lhsDescriptionsElements.keys.count != rhsDescriptionsElements.keys.count) {
            return false
        }
        if (lhsDescriptionsElements.keys.reversed() != rhsDescriptionsElements.keys.reversed()) {
            return false
        }
        for descriptor in lhsDescriptionsElements.keys.reversed() {
            let lhsDes: DescriptionElementState? = lhsDescriptionsElements[descriptor]
            let rhsDes: DescriptionElementState? = rhsDescriptionsElements[descriptor]

            if (lhsDes == nil) {
                if (rhsDes != nil) {
                    return false
                }
            } else {
                if (rhsDes == nil) {
                    return false
                }
                if(lhsDes! != rhsDes!){
                    return false
                }
            }

        }


        return true
    }
}

