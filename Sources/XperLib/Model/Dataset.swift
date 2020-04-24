//
//  Dataset.swift
//  Xper
//
//  Created by Thomas Burguiere on 04/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

open class Dataset {
    open var name: String?
    open var detail: String?
    open var authors: [String] = []
    open var associatedWebsite: String?
    open var copyright: String?
    open var creationDate: Date?

    open var descriptors: [Descriptor] = []
    open var items: [Item] = []
    open var itemTrees: [Tree<Item>] = []
    open var descriptorTrees: [TreeType: Tree<Descriptor>] = [TreeType: Tree<Descriptor>]()
    open var resources: [Resource] = []

    var upToDate = true

    public init(name: String) {
        self.name = name
    }

    public init() {

    }

    deinit {
        for r in resources {
            r.object = nil
        }
    }

    open func getDescriptorByName(_ descriptorName: String) -> [Descriptor] {
        return descriptors.filter { (d: Descriptor) -> Bool in
            return d.name == descriptorName
        }
    }

    open func getDescriptorByName(_ descriptorName: String) -> Descriptor? {
        let filtered: [Descriptor] = self.descriptors.filter { (descriptor: Descriptor) -> Bool in
            descriptor.name == descriptorName
        }
        if (filtered.count > 0) {
            return filtered[0]
        }
        return filtered.count > 0 ? filtered[0] : nil
    }

    public static func getDescriptorNodeByState(descriptorTree: Tree<Descriptor>, state: State) -> Node<Descriptor>? {
        for descriptorNode in descriptorTree.nodes {
            if descriptorNode.object!.isCategorical {
                let catDesc = descriptorNode.object! as! CategoricalDescriptor
                for stateBis in catDesc.states {
                    if (stateBis === state) {
                        return descriptorNode;
                    }
                }
            }
        }
        return nil
    }
}
