//
//  Node.swift
//  Xper
//
//  Created by Thomas Burguiere on 03/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

open class Node<T: Treeable>: DatasetObjectWithResources, Equatable {
    open var object: T?
    open var name: String?
    open var detail: String?
    open var tree: Tree<T>?
    
    fileprivate var inapplicableStates: [State]?
    
    open func setInapplicableStates(_ inappStates: [State]) {
        if object is CategoricalDescriptor {
            inapplicableStates = inappStates
        }
    }
    
    open func getInapplicableStates() -> [State]? {
        if object is CategoricalDescriptor {
            return inapplicableStates
        }
        return nil
    }
    
    open func addInapplicableState(_ state: State) throws {

        if !(object is Descriptor) {
            throw XperError(message: "cannot add Inapplicable State to node that doesnt contain descriptor")
        }
        if (self.parentNode == nil) {
            throw XperError(message: "cannot add Inapplicable State to node that doesnt have a parent")
        }
        if (state.descriptor == nil) {
            throw XperError(message: "cannot add Inapplicable State that doesnt have descriptor")
        }

        if inapplicableStates == nil {
            inapplicableStates = [State]()
        }
        inapplicableStates?.append(state)
    }

    open func getApplicableStates() -> Array<State> {
        var appStates = Array<State>()

        if (self.parentNode != nil && self.parentNode?.object is CategoricalDescriptor) {
            let states = (self.parentNode?.object as! CategoricalDescriptor).getStates()

            for state in states {
                if (!self.inapplicableStates!.contains(state)) {
                    appStates.append(state)
                }
            }
        }
        return appStates
    }


    fileprivate var parentNode: Node<T>?
    fileprivate var childNodes: [Node<T>] = []
    
    public init (){}
    
    public init(object: T) {
        self.object = object
    }
    
    open func getParentNode() -> Node<T>? {
        return self.parentNode
    }
    
    open func setParentNode(_ parentNode: Node<T>) {
        self.parentNode = parentNode;
        parentNode.childNodes.append(self);
        
    }
    
    open func getChildNodes() -> [Node<T>] {
        return self.childNodes
    }
    
    open func setChildNodes(_ childNodes:[Node<T>]) {
        for childNode in  childNodes {
            childNode.setParentNode(self);
        }
        self.childNodes = childNodes;
    }
    // MARK: DatasetObjectWithResources
    open var resources: [Resource] = []
    deinit{
        for r in resources {
            r.object = nil
        }
    }

    public static func ==(lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.name == rhs.name && lhs.object == rhs.object
    }
}
