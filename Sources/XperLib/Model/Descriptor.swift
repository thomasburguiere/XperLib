//
//  Descriptor.swift
//  Xper
//
//  Created by Thomas Burguiere on 10/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

public func ==(lhs: Descriptor, rhs: Descriptor) -> Bool {
    if (lhs.id == rhs.id && lhs.isCategorical == rhs.isCategorical && lhs.isQuantitative == rhs.isQuantitative) == false {
        return false
    }
    if lhs.isQuantitative {
        return (lhs as! QuantitativeDescriptor).measurementUnit == (rhs as! QuantitativeDescriptor).measurementUnit
    } else if lhs.isCategorical {
        let lhsc = lhs as! CategoricalDescriptor
        let rhsc = rhs as! CategoricalDescriptor
        return lhsc.states == rhsc.states
    }
    return true
}
open class Descriptor: DatasetObjectWithResources, Hashable, Treeable, CustomStringConvertible {
    
    open var id: String
    open var name: String?
    open var quality: String?
    open var detail: String?
    open var globalWeight: Int = 3
    open var resources: [Resource] = []
    
    open var isQuantitative: Bool {
        return self is QuantitativeDescriptor
    }
    
    open var isCategorical: Bool {
        return self is CategoricalDescriptor
    }
    
    open var description: String {
        return "\(String(describing: name)) - \(id)"
    }

    public init(id:String, name: String) {
        self.id = id
        self.name = name
    }
    public init(id:String) {
        self.id = id
    }
    
    deinit{
        for r in resources {
            r.object = nil
        }
    }
    enum type {
        case categorical
        case quantitative
        case computed
        case unknown
    }
    
    // MARK: Hashable
    open var hashValue : Int {
        get {
            return id.hashValue
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
