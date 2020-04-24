//
//  Tree.swift
//  Xper
//
//  Created by Thomas Burguiere on 03/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

open class Tree<T: Treeable> {

    open var id: String?
    open var name: String?
    open var detail: String?
    open var type: TreeType = .other
    open private(set) var nodes: [Node<T>] = []

    public init(_ id: String) {
        self.id = id
    }

    public init() {
    }

    open var rootNodes: [Node<T>] {
        return nodes.filter({ (node: Node<T>) -> Bool in
            return node.getParentNode() == nil
        })
    }

    open var isDependencyTree: Bool {
        return self.type == .descriptorDependency
    }
    open var isGroupTree: Bool {
        return self.type == .descriptorGroup
    }

    open func addNode(_ node: Node<T>) {
        nodes.append(node)
        node.tree = self
    }

    open func addNodes(_ nodes: [Node<T>]) {
        for node in nodes {
            addNode(node)
        }
    }

    open func removeNode(_ nodeToRemove: Node<T>) {
        nodes = nodes.filter({ (node: Node<T>) -> Bool in
            return node !== nodeToRemove
        })
        nodeToRemove.tree = nil
    }

    open func removeNodes(_ nodesToRemove: [Node<T>]) {
        for nodeToRemove in nodesToRemove {
            removeNode(nodeToRemove)
        }
    }

    public static func getRootNodes(nodes: Array<Node<T>>) -> Array<Node<T>> {
        return nodes.filter({ (node: Node) -> Bool in
            return node.getParentNode() == nil
        })
    }

    open func findDescriptorNodeByState(_ state2find: State) -> Node<T>? {
        if self.type != .descriptorDependency || nodes.count == 0 {
            return nil
        }
        if nodes[0].object is Descriptor == false {
            return nil
        }

        for node in nodes {
            if node.object != nil {
                for state in (node.object as! CategoricalDescriptor).states {
                    if state.id == state2find.id {
                        return node
                    }
                }
            }
        }
        return nil
    }

    open func findNodeByObjectId(_ id: String) -> Node<T> {
        return nodes.filter { (node: Node<T>) -> Bool in
            return node.object?.id == id
        }[0]
    }
}
