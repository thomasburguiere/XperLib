//
//  SDDParserTestCicho.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 06/05/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import XCTest
@testable import XperLib

class SDDParserTestCicho: XCTestCase {
    
    var nsxmlParsedGenetsDataset: Dataset?
    
    //MARK: setup functions

    fileprivate func initializeNsxmlDatasetForSddFile(_ sddFileName: String) -> Dataset {
        if nsxmlParsedGenetsDataset == nil {
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/cichorieae.sdd.xml"))
            
            let parser = SddNSXMLParser(posititionOfDescriptorDependencyTree: -1, positionOfDescriptorGroupTree: 1)
            nsxmlParsedGenetsDataset = parser.parseDataset(fileData)
        }
        return nsxmlParsedGenetsDataset!
    }
    
    
    //MARK: Item parsing sanity checks
    
    func skipped_test_nsxml_parsing_extracts_items_correctly () {
        let dataset = initializeNsxmlDatasetForSddFile("cichorieae")
        XCTAssertEqual(dataset.name, "Cichorieae")
        
        XCTAssertEqual(dataset.items.count, 144)
        let ovItem = dataset.items.filter{$0.id == "ov"}.first
        
        XCTAssertNotNil(ovItem)
        
        XCTAssertEqual(ovItem!.name, "Crepis pulchra L.")
    }
    
    
    //MARK: Descriptor parsing sanity checks
    
    func skipped_test_nsxml_parsing_extracts_descriptors_correctly () {
        let dataset = initializeNsxmlDatasetForSddFile("cichorieae")
        XCTAssertEqual(dataset.name, "Cichorieae")
        
        XCTAssertEqual(dataset.descriptors.count, 303)
        
        let qDescriptor = dataset.descriptors.filter{$0.id == "Q"}.first
        XCTAssertNotNil(qDescriptor!.id)
        XCTAssertEqual(qDescriptor!.name, "growth form <general>")
        
        let qCategoricalDesc = qDescriptor! as! CategoricalDescriptor
        XCTAssertEqual(qCategoricalDesc.states.count, 7)
        
        let rState = qCategoricalDesc.states.filter{$0.id == "R"}.first
        XCTAssertNotNil(rState)
        XCTAssertEqual(rState?.name, "shrub")
        
        
        let daDescriptor = dataset.descriptors.filter{$0.id == "da"}.first
        XCTAssertNotNil(daDescriptor)
        XCTAssertTrue(daDescriptor!.isQuantitative)
        XCTAssertEqual(daDescriptor!.name, "height")
        XCTAssertEqual((daDescriptor! as! QuantitativeDescriptor).measurementUnit, "cm")
    }
    
    
    func skipped_test_nsxml_parsing_extracts_descriptor_dependency_tree_correctly() {
        
        let dataset = initializeNsxmlDatasetForSddFile("cichorieae")
        XCTAssertEqual(dataset.name, "Cichorieae")
        
        XCTAssertEqual(dataset.descriptorTrees[.descriptorDependency]?.nodes.count, dataset.descriptors.count)
        
        let qNode = dataset.descriptorTrees[.descriptorDependency]?.nodes.filter{$0.object!.id == "Q"}.first!
        XCTAssertNotNil(qNode)
    }
    
    func skipped_test_nsxml_parsing_extracts_descriptor_group_tree_correctly() {
        
        let dataset = initializeNsxmlDatasetForSddFile("cichorieae")
        XCTAssertEqual(dataset.name, "Cichorieae")
        
        let groupsTree = dataset.descriptorTrees[.descriptorGroup]!
        
        let groupNodes = groupsTree.nodes.filter{$0.name != nil}
        XCTAssertEqual(groupNodes.count, 30)
        let groupNodesContainNoObjects = groupNodes.reduce(true) {$0 && $1.object == nil}
        XCTAssert(groupNodesContainNoObjects, "group nodes should not contain objects!!")
        let groupNodesHaveNoParents = groupNodes.reduce(true) {$0 && $1.getParentNode() == nil}
        XCTAssert(groupNodesHaveNoParents, "group nodes should not have parent nodes!!")
        
        
        
        let descriptorNodes = groupsTree.nodes.filter{$0.object != nil}
        XCTAssertEqual(descriptorNodes.count, dataset.descriptors.count)
        let descriptorNodesHaveNoNames = descriptorNodes.reduce(true) {$0 && $1.name == nil}
        XCTAssert(descriptorNodesHaveNoNames, "descriptor nodes should not have names!!")
        let descriptorNodesHaveParentNode = descriptorNodes.reduce(true) {$0 && $1.getParentNode() != nil}
        XCTAssert(descriptorNodesHaveParentNode, "descriptor nodes should have parent nodes!!")
        
        for descriptorNode in descriptorNodes {
            let descriptorNodeParentIsInGroupNodes = groupNodes.filter{$0 === descriptorNode.getParentNode()}.count > 0
            XCTAssert(descriptorNodeParentIsInGroupNodes)
        }
        
    }
    
    func skipped_test_nsxml_parsing_extracts_item_categorical_descriptions_correctly() {
        let dataset = initializeNsxmlDatasetForSddFile("cichorieae")
        XCTAssertEqual(dataset.name, "Cichorieae")
        
        let allItemsHaveDescription = dataset.items.reduce(true, {$0 && $1.itemDescription != nil})
        XCTAssert(allItemsHaveDescription, "All items in dataset should have a description!!")
        
        let ovItem = dataset.items.filter{$0.id == "ov"}.first!
        let qDescriptor = dataset.descriptors.filter{$0.id == "Q"}.first! as! CategoricalDescriptor
        let qDescStates = qDescriptor.states
        
        let ovDescription = ovItem.itemDescription
        let des = ovDescription!.descriptionElements[qDescriptor]
        
        var qDescStatesContainsSelectedStateInDes = true
        
        for selectedState in (des?.selectedStates)! {
            qDescStatesContainsSelectedStateInDes = qDescStatesContainsSelectedStateInDes && qDescStates.contains{$0 === selectedState}
        }
        
        XCTAssert(qDescStatesContainsSelectedStateInDes, "states in description \(String(describing: des?.selectedStates)) should belong to descriptor states \(qDescStates)")
    }
    
    func skipped_test_nsxml_parsing_extracts_item_numerical_descriptions_correctly() {
        let dataset = initializeNsxmlDatasetForSddFile("cichorieae")
        XCTAssertEqual(dataset.name, "Cichorieae")
        
        let allItemsHaveDescription = dataset.items.reduce(true, {$0 && $1.itemDescription != nil})
        XCTAssert(allItemsHaveDescription, "All items in dataset should have a description!!")
        
        let ovItem = dataset.items.filter{$0.id == "ov"}.first!
        let daDescriptor = dataset.descriptors.filter{$0.id == "da"}.first! as! QuantitativeDescriptor
        
        let ovDescription = ovItem.itemDescription
        let des = ovDescription!.descriptionElements[daDescriptor]
        
        XCTAssertNotNil(des?.quantitativeMeasure)
        XCTAssertEqual(des?.quantitativeMeasure?.min, 5) // cf line 22119 of test file
        XCTAssertEqual(des?.quantitativeMeasure?.uMethLower, 30)
        XCTAssertEqual(des?.quantitativeMeasure?.uMethUpper, 70)
        XCTAssertEqual(des?.quantitativeMeasure?.max, 120)
    }
}
