//
//  NodeTest.swift
//  Xper
//
//  Created by Thomas Burguiere on 03/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

import XCTest
@testable import XperLib

class NodeTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_tree_static_root_node() {

        let root = Node<Descriptor>()
        root.name = "root"
        let child = Node<Descriptor>()
        child.setParentNode(root)
        let nodes: Array<Node<Descriptor>> = [root, child]


        let actual: [Node<Descriptor>] = Tree.getRootNodes(nodes: nodes)
        XCTAssertEqual(actual.count, 1)
        XCTAssertEqual(actual[0].name, "root")
    }

    func test_node_with_same_name_and_no_content_are_equal() {
        // given
        let node1: Node<Descriptor>
        let node2: Node<Descriptor>

        // when
        node1 = Node()
        node2 = Node()

        // then
        XCTAssertEqual(node1, node2)
    }

    func test_node_with_same_name_and_same_content_are_equal() {
        // given
        let node1: Node<Descriptor>
        let node2: Node<Descriptor>
        let desc = Descriptor(id: "1", name: "desc")

        // when
        node1 = Node(object: desc)
        node2 = Node(object: desc)

        // then
        XCTAssertEqual(node1, node2)
    }

    func test_node_with_different_name_and_no_content_are_not_equal() {
        // given
        let node1: Node<Descriptor>
        let node2: Node<Descriptor>

        // when
        node1 = Node()
        node1.name = "node1"
        node2 = Node()
        node2.name = "node2"

        // then
        XCTAssertNotEqual(node1, node2)
    }


    func test_node_with_same_name_and_different_content_are_equal() {
        // given
        let node1: Node<Descriptor>
        let node2: Node<Descriptor>
        let desc1 = Descriptor(id: "1", name: "desc1")
        let desc2 = Descriptor(id: "2", name: "desc2")

        // when
        node1 = Node(object: desc1)
        node2 = Node(object: desc2)

        // then
        XCTAssertNotEqual(node1, node2)
    }

    func test_cannot_inapplicable_state_to_node_that_doesnt_contain_descriptor() {
        let item = Item(id: "item")
        let node = Node(object: item)

        let state = State(id: "state", name: "state")

        let error: Any
        do {
            error = try node.addInapplicableState(state)
            XCTFail("Error should have been thrown")
        } catch {
            XCTAssertTrue(error is XperError)
            XCTAssertEqual((error as! XperError).message, "cannot add Inapplicable State to node that doesnt contain descriptor")
        }
    }

    func test_cannot_inapplicable_state_to_node_that_doesnt_have_parent() {
        let descriptor = CategoricalDescriptor(id: "item", name: "item")
        let node = Node(object: descriptor)

        let state = State(id: "state", name: "state")

        let error: Any
        do {
            error = try node.addInapplicableState(state)
            XCTFail("Error should have been thrown")
        } catch {
            XCTAssertTrue(error is XperError)
            XCTAssertEqual((error as! XperError).message, "cannot add Inapplicable State to node that doesnt have a parent")
        }
    }

    func test_cannot_add_inapplicable_state_if_state_doesnt_have_descriptor() {
        let descriptor = CategoricalDescriptor(id: "descriptor", name: "descriptor")
        let parentDescriptor = CategoricalDescriptor(id: "parentDescriptor", name: "parentDescriptor")
        let parentNode = Node(object: parentDescriptor)
        let node = Node(object: descriptor)
        node.setParentNode(parentNode)

        let state = State(id: "state", name: "state")

        let error: Any
        do {
            error = try node.addInapplicableState(state)
            XCTFail("Error should have been thrown")
        } catch {
            XCTAssertTrue(error is XperError)
            XCTAssertEqual((error as! XperError).message, "cannot add Inapplicable State that doesnt have descriptor")
        }
    }


    func test_find_applicableStates_in_discrete_descriptor_node() {
        let parentDescriptor = CategoricalDescriptor(id: "tail_presence", name: "presence of tail")
        let tailPresent = State(id: "tailPresent", name: "yes")
        let tailAbsent = State(id: "tailAbsent", name: "no")
        parentDescriptor.setStates(states: [tailAbsent, tailPresent])

        let childDescriptor = CategoricalDescriptor(id: "tail_spotted", name: "spots on tail")
        let spotsLot = State(id: "spotsLot", name: "lots")
        let spotsFew = State(id: "spotsFew", name: "few")
        let spotsNo = State(id: "spotsNo", name: "no")
        childDescriptor.setStates(states: [spotsNo, spotsFew, spotsLot])

        let parentNode = Node<Descriptor>(object: parentDescriptor)
        let childNode = Node<Descriptor>(object: childDescriptor)
        childNode.setParentNode(parentNode)

        try! childNode.addInapplicableState(tailAbsent)
        XCTAssertTrue(childNode.getInapplicableStates()!.contains(tailAbsent))
        XCTAssertTrue(childNode.getApplicableStates().contains(tailPresent))

    }
    
    func test_childNodes_didSet() {
        let item1 = Item(id: "item1")
        let itemNode1 = Node<Item>(object: item1)
        
        
        let item11 = Item(id: "item11")
        let item12 = Item(id: "item12")
        let itemNode11 = Node<Item>(object: item11)
        let itemNode12 = Node<Item>(object: item12)
        
        itemNode1.setChildNodes([itemNode11, itemNode12])
        
        XCTAssertTrue(itemNode1 === itemNode11.getParentNode()!)
        XCTAssertTrue(itemNode1 === itemNode12.getParentNode()!)
    }
    
    func test_parentNode_didSet() {
        let item1 = Item(id: "item1")
        let itemNode1 = Node<Item>(object: item1)
        
        let item11 = Item(id: "item11")
        let itemNode11 = Node<Item>(object: item11)
        
        itemNode11.setParentNode(itemNode1)
        
        XCTAssertTrue(itemNode1.getChildNodes()[0] === itemNode11)
    }
    
    func test_childNodes_for_Descriptor() {
        let desc1 = Descriptor(id: "desc1", name: "de")
        let descNode1 = Node<Descriptor>(object: desc1)
        
        
        let desc11 = Descriptor(id: "desc11", name: "de" )
        let desc12 = Descriptor(id: "desc12", name: "de")
        let descNode11 =  Node<Descriptor>(object: desc11)
        let descNode12 =  Node<Descriptor>(object: desc12)
        
        descNode1.setChildNodes([descNode11, descNode12])
        
        XCTAssertTrue(descNode1 === descNode11.getParentNode()!)
        XCTAssertTrue(descNode1 === descNode12.getParentNode()!)
    }
    
    func test_parentNode_for_Descriptor() {
        let desc1 = Descriptor(id: "desc1", name: "de")
        let descNode1 = Node<Descriptor>(object: desc1)
        
        let desc11 = Descriptor(id: "desc11", name: "de")
        let descNode11 = Node<Descriptor>(object: desc11)
        
        descNode11.setParentNode(descNode1)
        
        XCTAssertTrue(descNode1.getChildNodes()[0] === descNode11)
    }
    
    func test_InapplicableStates_are_set_on_categoricalDescriptor_node() {
        let inappStates = [State(id: "s1"), State(id: "s2")]
        
        let dNode = Node<Descriptor>(object: CategoricalDescriptor(id:"id"))
        dNode.setInapplicableStates(inappStates)
        XCTAssert(dNode.getInapplicableStates() != nil)
    }
    
    func test_InapplicableStates_are_not_set_on_non_categoricalDescriptor_node() {
        let inappStates = [State(id: "s1"), State(id: "s2")]
        
        let dNode = Node<Item>(object: Item(id:"id"))
        dNode.setInapplicableStates(inappStates)
        XCTAssert(dNode.getInapplicableStates() == nil)
    }
    
}
