//
//  TreeTest.swift
//  Xper
//
//  Created by Thomas Burguiere on 03/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

import XCTest
@testable import XperLib

class TreeTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_tree_init() {
        let tree = Tree<Descriptor>()
        XCTAssertNotNil(tree)
        XCTAssertEqual(tree.type, TreeType.other)
    }

    func test_tree_root_node() {
        let tree = Tree<Descriptor>()

        let root = Node<Descriptor>()
        root.name = "root"
        let child = Node<Descriptor>()
        child.setParentNode(root)
        child.name = "child"

        tree.addNode(root)
        tree.addNode(child)

        let actual: [Node<Descriptor>] = tree.rootNodes
        XCTAssertEqual(actual.count, 1)
        XCTAssertEqual(actual[0].name, "root")
    }

    func test_node_removal_works() {
        let tree = Tree<Descriptor>()

        let root = Node<Descriptor>()
        let child = Node<Descriptor>()
        child.setParentNode(root)

        tree.addNode(root)
        tree.addNode(child)

        // when
        tree.removeNode(child)
        XCTAssertEqual(tree.nodes.count, 1)
    }

    func test_find_node_buy_object_id() {
        let objectId = "1"
        let descriptor1: Descriptor = Descriptor(id: objectId, name: "descr1")
        let descriptor2: Descriptor = Descriptor(id: "2", name: "descr2")

        let tree: Tree = Tree<Descriptor>()


        let root = Node<Descriptor>(object: descriptor1)
        let child = Node<Descriptor>(object: descriptor2)
        child.setParentNode(root)

        tree.addNode(root)
        tree.addNode(child)

        // when
        let actual: Node<Descriptor>? = tree.findNodeByObjectId(objectId)

        // then
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual?.object?.id, objectId)
    }


    func test_getRootNodes_for_Item() {
        let item1 = Item(id: "item1")
        let itemNode1 = Node<Item>(object: item1)
        
        
        let item11 = Item(id: "item11")
        let item12 = Item(id: "item12")
        let itemNode11 = Node<Item>(object: item11)
        let itemNode12 = Node<Item>(object: item12)
        
        itemNode1.setChildNodes([itemNode11, itemNode12])
        
        let itemT = Tree<Item>()
        itemT.addNodes([itemNode11, itemNode1, itemNode12])
        
        XCTAssertTrue(itemT.rootNodes.count == 1)
        XCTAssertTrue(itemT.rootNodes[0] === itemNode1)
    }
    
    func test_addNode_sets_the_nodes_tree_for_Item() {
        let item1 = Item(id: "item1")
        let itemNode1 = Node<Item>(object: item1)
        
        let itemT = Tree<Item>()
        itemT.addNode(itemNode1)
        
        XCTAssertTrue(itemNode1.tree! === itemT)
        
    }
    
    func test_removeNode_works() {
        let item1 = Item(id: "item1")
        let itemNode1 = Node<Item>(object: item1)
        
        
        let item11 = Item(id: "item11")
        let item12 = Item(id: "item12")
        let itemNode11 = Node<Item>(object: item11)
        let itemNode12 = Node<Item>(object: item12)
        
        itemNode1.setChildNodes([itemNode11, itemNode12])
        
        let itemT = Tree<Item>()
        itemT.addNodes([itemNode11, itemNode1, itemNode12])
        
        
        XCTAssertEqual(itemT.nodes.count, 3)
        XCTAssertNotNil(itemNode1.tree)
        XCTAssertNotNil(itemNode11.tree)
        XCTAssertNotNil(itemNode12.tree)
        
        itemT.removeNode(itemNode11)
        
        XCTAssertEqual(itemT.nodes.count, 2)
        XCTAssertNotNil(itemNode1.tree)
        XCTAssertNil(itemNode11.tree)
        XCTAssertNotNil(itemNode12.tree)
        
    }
    func test_removeNodes_works() {
        let item1 = Item(id: "item1")
        let itemNode1 = Node<Item>(object: item1)
        
        
        let item11 = Item(id: "item11")
        let item12 = Item(id: "item12")
        let itemNode11 = Node<Item>(object: item11)
        let itemNode12 = Node<Item>(object: item12)
        
        itemNode1.setChildNodes([itemNode11, itemNode12])
        
        let itemT = Tree<Item>()
        itemT.addNodes([itemNode11, itemNode1, itemNode12])
        
        
        XCTAssertEqual(itemT.nodes.count, 3)
        XCTAssertNotNil(itemNode1.tree)
        XCTAssertNotNil(itemNode11.tree)
        XCTAssertNotNil(itemNode12.tree)
        
        itemT.removeNodes([itemNode11, itemNode1])
        
        XCTAssertEqual(itemT.nodes.count, 1)
        XCTAssertNil(itemNode1.tree)
        XCTAssertNil(itemNode11.tree)
        XCTAssertNotNil(itemNode12.tree)
        XCTAssertTrue(itemT.nodes[0] === itemNode12)
    }
    
    func test_getRootNodes_for_Descriptor() {
        let desc1 = Descriptor(id: "item1", name: "de")
        let descNode1 = Node<Descriptor>(object: desc1)
        
        
        let desc11 = Descriptor(id: "item11", name: "de")
        let desc12 = Descriptor(id: "item12", name: "de")
        let descNode11 = Node<Descriptor>(object: desc11)
        let descNode12 = Node<Descriptor>(object: desc12)
        
        descNode1.setChildNodes([descNode11, descNode12])
        
        let descTree = Tree<Descriptor>()
        descTree.addNodes([descNode11, descNode1, descNode12])
        
        XCTAssertTrue(descTree.rootNodes.count == 1)
        XCTAssertTrue(descTree.rootNodes[0] === descNode1)
    }
    
    func test_addNode_sets_the_nodes_tree_for_Descriptor() {
        let item1 = Descriptor(id: "item1", name: "de")
        let itemNode1 = Node<Descriptor>(object: item1)
        
        let itemT = Tree<Descriptor>()
        itemT.addNode(itemNode1)
        
        XCTAssertTrue(itemNode1.tree! === itemT)
    }
    
    func test_findDescriptorNodeByState_should_return_correct_node() {
        let desc1 = CategoricalDescriptor(id: "desc1")
        desc1.states = [State(id: "s1"), State(id: "s2")]
        
        let descNode1 = Node<Descriptor>(object: desc1)
        
        
        let desc11 = CategoricalDescriptor(id: "desc11")
        desc11.states = [State(id: "s3"), State(id: "s4")]
        let descNode11 = Node<Descriptor>(object: desc11)
        
        let desc12 = CategoricalDescriptor(id: "desc12")
        desc12.states = [State(id: "s5"), State(id: "s6")]
        let descNode12 = Node<Descriptor>(object: desc12)
        
        descNode1.setChildNodes([descNode11, descNode12])
        
        let descTree = Tree<Descriptor>()
        descTree.type = .descriptorDependency
        
        descTree.addNodes([descNode11, descNode1, descNode12])
        
        XCTAssertTrue(descTree.findDescriptorNodeByState(State(id: "s3")) === descNode11)
    }
    
    func test_findDescriptorNodeByState_should_return_nil_if_nothing_found() {
        let desc1 = CategoricalDescriptor(id: "desc1")
        desc1.states = [State(id: "s1"), State(id: "s2")]
        
        let descNode1 = Node<Descriptor>(object: desc1)
        
        
        let desc11 = CategoricalDescriptor(id: "desc11")
        desc11.states = [State(id: "s3"), State(id: "s4")]
        let descNode11 = Node<Descriptor>(object: desc11)
        
        let desc12 = CategoricalDescriptor(id: "desc12")
        desc12.states = [State(id: "s5"), State(id: "s6")]
        let descNode12 = Node<Descriptor>(object: desc12)
        
        descNode1.setChildNodes([descNode11, descNode12])
        
        let descTree = Tree<Descriptor>()
        descTree.type = .descriptorDependency
        
        descTree.addNodes([descNode11, descNode1, descNode12])
        
        XCTAssertNil(descTree.findDescriptorNodeByState(State(id: "s33")))
    }
    
    
    
    func test_findDescriptorNodeByState_should_return_nil_if_tree_is_not_dependencyTree() {
        let desc1 = CategoricalDescriptor(id: "desc1")
        desc1.states = [State(id: "s1"), State(id: "s2")]
        
        let descNode1 = Node<Descriptor>(object: desc1)
        
        
        let desc11 = CategoricalDescriptor(id: "desc11")
        desc11.states = [State(id: "s3"), State(id: "s4")]
        let descNode11 = Node<Descriptor>(object: desc11)
        
        let desc12 = CategoricalDescriptor(id: "desc12")
        desc12.states = [State(id: "s5"), State(id: "s6")]
        let descNode12 = Node<Descriptor>(object: desc12)
        
        descNode1.setChildNodes([descNode11, descNode12])
        
        let descTree = Tree<Descriptor>()
        descTree.type = .other
        
        descTree.addNodes([descNode11, descNode1, descNode12])
        
        XCTAssertNil(descTree.findDescriptorNodeByState(State(id: "s3")))
    }
    
    
    
    func test_findDescriptorNodeByState_should_return_nil_if_tree_does_not_contain_descriptors() {
        let item1 = Item(id: "item1")
        let itemNode1 = Node<Item>(object: item1)
        
        
        let item11 = Item(id: "item11")
        let item12 = Item(id: "item12")
        let itemNode11 = Node<Item>(object: item11)
        let itemNode12 = Node<Item>(object: item12)
        
        itemNode1.setChildNodes([itemNode11, itemNode12])
        
        let itemTree = Tree<Item>()
        itemTree.type = .descriptorDependency
        itemTree.addNodes([itemNode11, itemNode1, itemNode12])
        
        XCTAssertNil(itemTree.findDescriptorNodeByState(State(id: "s3")))
    }

}

