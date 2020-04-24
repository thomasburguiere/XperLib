//
//  Resource.swift
//  Xper
//
//  Created by Thomas Burguiere on 10/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//


open class Resource {
    open var id: String?
    open var name: String?
    open var type: ResourceType
    open var url: String?
    open var author: String?
    open var object: DatasetObjectWithResources?

    public init(id:String?) {
        self.id = id
        self.type = .other
    }
}
