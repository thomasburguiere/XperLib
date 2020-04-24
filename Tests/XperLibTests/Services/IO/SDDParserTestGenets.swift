//
//  XperLibTests.swift
//  XperLibTests
//
//  Created by Thomas Burguiere on 09/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import XCTest
@testable import XperLib

class SDDParserTestGenets: XCTestCase {

    var nsxmlParsedGenetsDataset: Dataset?

    fileprivate func initializeNsxmlDatasetForSddFile(_ sddFileName: String) -> Dataset {
        if nsxmlParsedGenetsDataset == nil {
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/genetta.sdd.xml"))

            let parser = SddNSXMLParser()
            nsxmlParsedGenetsDataset = parser.parseDataset(fileData)
        }
        return nsxmlParsedGenetsDataset!
    }


    //MARK: Item parsing sanity checks

    func skipped_test_nsxml_parsing_extracts_items_correctly_genetta () {
        let dataset = initializeNsxmlDatasetForSddFile("genetta")
        XCTAssertEqual(dataset.name, "Genets")

        XCTAssertEqual(dataset.items.count, 19)
        let t20Item = dataset.items.filter{$0.id == "t20"}.first!

        XCTAssertNotNil(t20Item)

        XCTAssertEqual(t20Item.name, "Genetta thierryi")
        XCTAssertEqual(t20Item.detail, "<i>Genetta thierryi</i> Matschie, 1902<br><br><strong>Common name</strong>: Hausa genet.<br><strong>Synonyms</strong>: <i>rubiginosa</i> Pucheran, 1855; <i>villiersi</i> Dekeyser, 1949.<br><strong>Distribution</strong>: Benin, Burkina Faso, Cameroon, Gambia, Ghana, Guinea Bissau, Ivory Coast, Mali, Nigeria, Niger, Sierra Leone, Senegal, Togo.<br><strong>Habitat</strong>: brush-grass savannah, Guinean savannah, moist woodlands.<br><strong>Sympatric species</strong>: <i>G. genetta, G. maculata, G. pardina</i> .")

        XCTAssertEqual(t20Item.resources.count, 4)
        XCTAssertEqual(t20Item.resources.first!.id, "m252")
        XCTAssertEqual(t20Item.resources.first!.name, "Genetta thierryi - m7")
        XCTAssertEqual(t20Item.resources.first!.url!, "http://lully.snv.jussieu.fr/images_genettas/Genthi_Burkina_Faso.jpg")
        XCTAssertEqual(t20Item.resources.first!.type, ResourceType.image)

    }


    //MARK: Descriptor parsing sanity checks

    func skipped_test_nsxml_parsing_extracts_descriptors_correctly_genetta () {
        let dataset = initializeNsxmlDatasetForSddFile("genetta")
        XCTAssertEqual(dataset.name, "Genets")

        XCTAssertEqual(dataset.descriptors.count, 45)

        let c47Descriptor = dataset.descriptors.filter{$0.id == "c47"}.first!
        XCTAssertNotNil(c47Descriptor.id)
        XCTAssertEqual(c47Descriptor.name, "Shape of crest of insertion of temporal muscles (upper part of the parietal)")
        XCTAssertEqual(c47Descriptor.detail, "_c47_")

        XCTAssertEqual(c47Descriptor.resources.count, 3)

        let m164Resource =  c47Descriptor.resources.filter{$0.id == "m164"}.first!
        XCTAssertNotNil(m164Resource)
        XCTAssertEqual(m164Resource.name, "Shape of crest of insertion of temporal muscles (upper part of the parietal) - m77")
        XCTAssertEqual(m164Resource.url!, "http://lully.snv.jussieu.fr/images_genettas/1_Crest_large.jpg")
        XCTAssertEqual(m164Resource.type, ResourceType.image)

        let c47CategoricalDesc = c47Descriptor as! CategoricalDescriptor
        XCTAssertEqual(c47CategoricalDesc.states.count, 3)

        let s115State = c47CategoricalDesc.states.filter{$0.id == "s115"}.first!
        XCTAssertNotNil(s115State)
        XCTAssertEqual(s115State.name, "large stripe")
        XCTAssertEqual(s115State.detail, "_s115_")

        XCTAssertEqual(s115State.resources.count, 1)
        XCTAssertEqual(s115State.resources.first!.id, "m167")
        XCTAssertEqual(s115State.resources.first!.name, "large stripe - m80")
        XCTAssertEqual(s115State.resources.first!.url!, "http://lully.snv.jussieu.fr/images_genettas/1_Crest_large.jpg")
        XCTAssertEqual(s115State.resources.first!.type, ResourceType.image)
    }


    func skipped_test_nsxml_parsing_extracts_descriptor_dependency_tree_correctly() {

        let dataset = initializeNsxmlDatasetForSddFile("genetta")
        XCTAssertEqual(dataset.name, "Genets")

        XCTAssertEqual(dataset.descriptorTrees[.descriptorDependency]?.nodes.count, dataset.descriptors.count)

        let c81DescriptorNode = dataset.descriptorTrees[.descriptorDependency]?.nodes.filter{$0.object!.id == "c81"}.first!
        XCTAssertNotNil(c81DescriptorNode)
        XCTAssertEqual(c81DescriptorNode?.getInapplicableStates()?.count, 1)
        XCTAssertEqual(c81DescriptorNode?.getInapplicableStates()?.filter{$0.id == "s194"}.count, 1)

        let c87DescriptorNode = dataset.descriptorTrees[.descriptorDependency]?.nodes.filter{$0.object!.id == "c87"}.first!
        XCTAssertNotNil(c87DescriptorNode)
        XCTAssertEqual(c87DescriptorNode?.getInapplicableStates()?.count, 1)
        XCTAssertEqual(c87DescriptorNode?.getInapplicableStates()?.filter{$0.id == "s216"}.count, 1)

    }

    func skipped_test_nsxml_parsing_extracts_descriptor_group_tree_correctly() {

        let dataset = initializeNsxmlDatasetForSddFile("genetta")
        XCTAssertEqual(dataset.name, "Genets")

        let groupsTree = dataset.descriptorTrees[.descriptorGroup]!

        let groupNodes = groupsTree.nodes.filter{$0.name != nil}
        XCTAssertEqual(groupNodes.count, 7)
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

    func skipped_test_nsxml_parsing_extracts_item_descriptions_correctly() {
        let dataset = initializeNsxmlDatasetForSddFile("genetta")
        XCTAssertEqual(dataset.name, "Genets")

        let allItemsHaveDescription = dataset.items.reduce(true, {$0 && $1.itemDescription != nil})
        XCTAssert(allItemsHaveDescription, "All items in dataset should have a description!!")

        let i20 = dataset.items.filter{$0.id == "t20"}.first!
        let d54 = dataset.descriptors.filter{$0.id == "c54"}.first! as! CategoricalDescriptor
        let d54States = d54.states

        let i20Description = i20.itemDescription
        let des = i20Description!.descriptionElements[d54]

        var d54StatesContainsSelectedStateInDes = true

        for selectedState in (des?.selectedStates)! {
            d54StatesContainsSelectedStateInDes = d54StatesContainsSelectedStateInDes && d54States.contains{$0 === selectedState}
        }

        XCTAssert(d54StatesContainsSelectedStateInDes, "states in description \(String(describing: des?.selectedStates)) should belong to descriptor states \(d54States)")
    }
}
