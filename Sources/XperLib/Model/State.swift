//
//  State.swift
//  Xper
//
//  Created by Thomas Burguiere on 10/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation
public func ==(lhs: State, rhs: State) -> Bool {
    return lhs.id == rhs.id
}
open class State : DatasetObjectWithResources, CustomStringConvertible, Hashable{
    open var id: String
    open var name : String?
    open var detail : String?
    open var resources: [Resource] = []
    open weak var descriptor: CategoricalDescriptor?
    
    public init(id: String){
        self.id = id
    }
    public init(id: String, name:String) {
        self.id = id
        self.name = name
    }
    
    open var description: String {
        return id
    }
    deinit{
        for r in resources {
            r.object = nil
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
