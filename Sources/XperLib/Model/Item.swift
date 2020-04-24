//
//  Item.swift
//  Xper
//
//  Created by Thomas Burguiere on 10/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

open class Item: DatasetObjectWithResources, Treeable, CustomStringConvertible, Equatable {
    open var id: String
    open var name: String?
    open var detail: String?
    open var alterNativeName: String?
    open var itemDescription: Description?
    open var resources: [Resource] = []

    public init(id: String) {
        self.id = id
    }

    public func describe(forDescriptor descriptor: CategoricalDescriptor, selectedStates: Array<State>) {
        if (self.itemDescription == nil) {
            self.itemDescription = Description()
        }
        let des = DescriptionElementState(selectedStates: selectedStates)
        self.itemDescription!.descriptionElements.updateValue(des, forKey: descriptor)
    }

    public func describe(forDescriptor descriptor: QuantitativeDescriptor, measure: QuantitativeMeasure) {
        if (self.itemDescription == nil) {
            self.itemDescription = Description()
        }
        let description = DescriptionElementState(quantitativeMeasure: measure)
        self.itemDescription!.descriptionElements.updateValue(description, forKey: descriptor)
    }

    open var description: String {
        return name!
    }

    public static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

    deinit {
        for r in resources {
            r.object = nil
        }
    }
}
