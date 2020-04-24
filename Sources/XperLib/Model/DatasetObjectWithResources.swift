//
//  DatasetObjectWithResources.swift
//  Xper
//
//  Created by Thomas Burguiere on 10/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

public protocol DatasetObjectWithResources {
    var resources: [Resource]  {get set}
}
public extension DatasetObjectWithResources {
    mutating func addResource(_ resourcesToAdd: Resource) {
        resources.append(resourcesToAdd)
        resourcesToAdd.object = self
    }


    mutating func addResources(_ addedResources: [Resource]) {
        for resource in addedResources {
            addResource(resource)
        }
    }

    mutating func removeResource(_ deletedResource: Resource) {
        resources = resources.filter({ (resource: Resource) -> Bool in
            if(resource === deletedResource){
                deletedResource.object = nil
                return false
            } else {
                return true
            }
        })
    }

    mutating func removeAllResources() {
        for resource in resources {
            resource.object = nil
        }
        resources = []
    }

}
