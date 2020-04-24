//
//  SddNSXMLParserDelegate.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 09/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

internal class SddNSXMLParserDelegate: NSObject, XMLParserDelegate {
    
    var buffer = ""
    var inDataset = false
    var isFirstDataset = true
    
    // MARK: first level nodes properties
    var inRepresentation = false
    var inLabel = false
    var inDetail = false
    var inTaxonNames = false
    var inMediaObjects = false
    var inMediaObject = false
    var inTaxonHierarchies = false
    var inDescriptiveConcepts = false
    var inDescriptiveConcept = false
    var inCodedDescriptions = false
    var inScope = false
    var inAgents = false
    
    // MARK: Taxa properties
    var inTaxonName = false
    var currentItem: Item?
    
    // MARK: MediaObjects properties
    var inType = false
    var inSource = false
    var mediaObjectRefToDatasetObjectDict = [String: DatasetObjectWithResources]()
    var currentResource: Resource?
    
    // MARK: Characters properties
    var inCharacters = false
    var inCategoricalCharacter = false
    var inStates = false
    var inStateDefinition = false
    var inQuantitativeCharacter = false
    
    var currentDescriptor: Descriptor?
    var currentState: State?
    
    // MARK: CharacterTrees properties
    var inNode = false
    
    var characterTreesCount = 0
    
    var isCharacterDependencyTree: Bool = false
    var isCharacterGroupTree: Bool = false
    
    var inCharacterTrees = false
    var inCharacterTree = false
    var inNodes = false
    var inCharNode = false
    var inCharacter = false
    var inDependencyRules = false
    var inInapplicableIf = false
    var inState = false
    var inParent = false
    var inMeasurementUnit = false
    
    var currentDescriptorDependencyTree: Tree<Descriptor>?
    var currentDescriptorGroupTree: Tree<Descriptor>?
    var currentDescriptorNode: Node<Descriptor>?
    var currentGroupDescriptorNode: Node<Descriptor>?
    
    var descriptiveConceptIdToNameDict = [String : String]()
    var groupNodeIdToNodeDict = [String : Node<Descriptor>]()
    var currentDescriptiveConceptId : String?
    
    var currentInapplicableStates: [State]?
    
    //MARK: item descriptions properties
    var currentlyDescribedItem: Item?
    var currentItemDescription: Description {
        get {
            if currentlyDescribedItem?.itemDescription == nil {
                return Description()
            }
            return (currentlyDescribedItem?.itemDescription)!
        }
        set {
            currentlyDescribedItem?.itemDescription = newValue
        }
    }
    
    var currentDescriptorUsedForDescription: Descriptor?
    var currentDescriptionElementState: DescriptionElementState?
    
    var currentCodedDescriptionId: String?
    var currentCodedDescriptionLabel: String?
    var itemsAreDefinedInCodedDescriptions = false
    
    var inCodedDescription = false
    
    var inSummaryData = false
    var inCategorical = false
    var inQuantitative = false
    var inMeasure = false
    
    
    var dataset: Dataset = Dataset()
    
    fileprivate var descriptorTreePositions = [TreeType: Int]()
    
    override init(){
        descriptorTreePositions[.descriptorDependency] = 1
        descriptorTreePositions[.descriptorGroup] = 2
        super.init()
    }
    
    init(positionOfDescriptorGroupTree: Int, posititionOfDescriptorDependencyTree: Int){
        
        descriptorTreePositions[.descriptorDependency] = posititionOfDescriptorDependencyTree
        descriptorTreePositions[.descriptorGroup] = positionOfDescriptorGroupTree
    }
    
    //MARK: parser methods
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        
        if elementName == "Dataset" {
            inDataset = true
        }
        else if elementName == "Representation" {
            inRepresentation = true
        }
        else if elementName == "Label" {
            inLabel = true
        }
        else if elementName == "Detail" {
            inDetail = true
        }
        else if elementName == "TaxonNames" {
            inTaxonNames = true
        }
        else if elementName == "TaxonName" {
            inTaxonName = true
            if inTaxonNames {
                currentItem = Item(id: attributeDict["id"]!)
            }
            else if inScope && inCodedDescription {
                currentlyDescribedItem = dataset.items.filter{$0.id == attributeDict["ref"]}.first
            }
        }
        else if elementName == "MediaObjects" {
            inMediaObjects = true
        }
        else if elementName == "MediaObject" {
            inMediaObject = true
            if inTaxonName && currentItem != nil && attributeDict["ref"] != nil {
                mediaObjectRefToDatasetObjectDict[attributeDict["ref"]!] = currentItem!
            }
            else if inCategoricalCharacter && !inStates && currentDescriptor != nil && attributeDict["ref"] != nil {
                mediaObjectRefToDatasetObjectDict[attributeDict["ref"]!] = currentDescriptor!
            }
            else if inStateDefinition && currentState != nil && attributeDict["ref"] != nil {
                mediaObjectRefToDatasetObjectDict[attributeDict["ref"]!] = currentState!
            }
            else if inMediaObjects {
                currentResource = Resource(id:attributeDict["id"])
                var datasetObjectWithResource = mediaObjectRefToDatasetObjectDict[attributeDict["id"]!]
                datasetObjectWithResource?.addResource(currentResource!)
            }
        }
        else if elementName == "TaxonHierarchies" {
            inTaxonHierarchies = true
        }
        else if elementName == "CodedDescriptions" {
            inCodedDescriptions = true
        }
        else if elementName == "CodedDescription" {
            inCodedDescription = true
            currentCodedDescriptionId = attributeDict["id"]
        }
        else if elementName == "SummaryData" {
            inSummaryData = true
            if currentlyDescribedItem == nil {
                itemsAreDefinedInCodedDescriptions = true
                currentItem = Item(id: currentCodedDescriptionId!)
                currentItem?.name = currentCodedDescriptionLabel
                currentlyDescribedItem = currentItem
            }
        }
        else if elementName == "Categorical" {
            inCategorical = true
            if inSummaryData && inCodedDescription {
                currentDescriptorUsedForDescription = dataset.descriptors.filter{$0.id == attributeDict["ref"]}[0]
                currentDescriptionElementState = DescriptionElementState()
            }
        }
        else if elementName == "Quantitative" {
            inQuantitative = true
            if inSummaryData && inCodedDescription {
                currentDescriptorUsedForDescription = dataset.descriptors.filter{$0.id == attributeDict["ref"]}[0]
                currentDescriptionElementState = DescriptionElementState()
                currentDescriptionElementState?.quantitativeMeasure = QuantitativeMeasure()
            }
        }
        else if elementName == "Measure" {
            inMeasure = true
            if attributeDict["type"] != nil && attributeDict["value"] != nil {
                switch attributeDict["type"]!.lowercased() {
                case "umethlower":
                    currentDescriptionElementState?.quantitativeMeasure?.uMethLower = Double(attributeDict["value"]!)
                case "umethupper":
                    currentDescriptionElementState?.quantitativeMeasure?.uMethUpper = Double(attributeDict["value"]!)
                case "mean":
                    currentDescriptionElementState?.quantitativeMeasure?.mean = Double(attributeDict["value"]!)
                case "min":
                    currentDescriptionElementState?.quantitativeMeasure?.min = Double(attributeDict["value"]!)
                case "max":
                    currentDescriptionElementState?.quantitativeMeasure?.max = Double(attributeDict["value"]!)
                default:
                    print("")
                }
            }
        }
        else if elementName == "Scope" {
            inScope = true;
        }
        else if elementName == "DescriptiveConcepts" {
            inDescriptiveConcepts = true
        }
        else if elementName == "DescriptiveConcept" {
            inDescriptiveConcept = true
            if inDescriptiveConcepts && attributeDict["id"] != nil {
                currentDescriptiveConceptId = attributeDict["id"]
            }
            else if inNode && isCharacterGroupTree {
                currentGroupDescriptorNode?.name = descriptiveConceptIdToNameDict[attributeDict["ref"]!]
            }
            
        }
        else if elementName == "Characters" {
            inCharacters = true
        }
        else if elementName == "CategoricalCharacter" {
            inCategoricalCharacter = true
            if attributeDict["id"] != nil {
                currentDescriptor = CategoricalDescriptor(id: attributeDict["id"]!)
            }
        }
        else if elementName == "QuantitativeCharacter" {
            inQuantitativeCharacter = true
            if attributeDict["id"] != nil {
                currentDescriptor = QuantitativeDescriptor(id: attributeDict["id"]!)
            }
        }
        else if elementName == "States" {
            inStates = true
        }
        else if elementName == "StateDefinition" {
            inStateDefinition = true
            if attributeDict["id"] != nil && currentDescriptor != nil && currentDescriptor is CategoricalDescriptor {
                currentState = State(id: attributeDict["id"]!)
                (currentDescriptor as! CategoricalDescriptor).states.append(currentState!)
                currentState?.descriptor = currentDescriptor as? CategoricalDescriptor
            }
        }
        else if elementName == "MeasurementUnit" {
            inMeasurementUnit = true
        }
            
        else if elementName == "CharacterTrees" {
            inCharacterTrees = true
        }
        else if elementName == "CharacterTree" {
            inCharacterTree = true
            characterTreesCount += 1
            if characterTreesCount == descriptorTreePositions[.descriptorDependency] {
                isCharacterDependencyTree = true
                currentDescriptorDependencyTree = Tree<Descriptor>()
                currentDescriptorDependencyTree?.type = .descriptorDependency
            }
            else if characterTreesCount == descriptorTreePositions[.descriptorGroup] {
                isCharacterDependencyTree = false
                isCharacterGroupTree = true
                currentDescriptorGroupTree = Tree<Descriptor>()
                currentDescriptorGroupTree?.type = .descriptorGroup
            }
        }
        else if elementName == "Nodes" {
            inNodes = true
        }
        else if elementName == "Node" {
            inNode = true
            if inNodes && isCharacterGroupTree {
                currentGroupDescriptorNode = Node<Descriptor>()
                groupNodeIdToNodeDict[attributeDict["id"]!] = currentGroupDescriptorNode
            }
        }
        else if elementName == "CharNode" {
            inCharNode = true
            currentDescriptorNode = Node<Descriptor>()
        }
        else if elementName == "Parent" {
            inParent = true
            if inCharNode && inNodes && isCharacterGroupTree && groupNodeIdToNodeDict[attributeDict["ref"]!] != nil {
                currentDescriptorNode?.setParentNode(groupNodeIdToNodeDict[attributeDict["ref"]!]!)
            }
        }
        else if elementName == "Character" {
            inCharacter = true
            if inCharNode && inNodes && currentDescriptorDependencyTree != nil && (currentDescriptorDependencyTree?.isDependencyTree)! && attributeDict["ref"] != nil {
                let descriptorInNode = dataset.descriptors.filter{$0.id == attributeDict["ref"]}.first
                if descriptorInNode != nil {
                    currentDescriptorNode?.object = descriptorInNode
                    if (currentInapplicableStates != nil && currentInapplicableStates?.count > 0){
                        currentDescriptorNode?.setInapplicableStates(currentInapplicableStates!)
                    }
                }
            }
            else if inParent && inNodes && isCharacterGroupTree {
                let descriptorInNode = dataset.descriptors.filter{$0.id == attributeDict["ref"]}[0]
                currentDescriptorNode?.object = descriptorInNode
                
            }
        }
        else if elementName == "DependencyRules" {
            inDependencyRules = true
        }
        else if elementName == "InapplicableIf" {
            inInapplicableIf = true
            if inDependencyRules && currentDescriptorDependencyTree != nil && (currentDescriptorDependencyTree?.isDependencyTree)! {
                currentInapplicableStates = []
            }
        }
        else if elementName == "State" {
            inState = true
            if inDependencyRules && inInapplicableIf && currentDescriptorDependencyTree != nil && (currentDescriptorDependencyTree?.isDependencyTree)! && attributeDict["ref"] != nil {
                if let stateReferred = dataset.findStateById(attributeDict["ref"]!) {
                    currentInapplicableStates?.append(stateReferred)
                }
            }
            else if inCategorical && inSummaryData && inCodedDescription {
                let stateId = attributeDict["ref"]
                let state = (currentDescriptorUsedForDescription as! CategoricalDescriptor).states.filter{$0.id == stateId}[0]
                currentDescriptionElementState?.selectedStates.append(state)
            }
        }
            
        else if elementName == "Type" {
            inType = true
        }
        else if elementName == "Source" {
            inSource = true
            if inMediaObject && currentResource != nil {
                currentResource?.url = attributeDict["href"]!
            }
        }
        else if elementName == "Agents" {
            inAgents = true
        }
        
    }
    
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Dataset" {
            inDataset = false
            isFirstDataset = false
        }
        else if elementName == "Representation" {
            inRepresentation = false
        }
        else if elementName == "Label" {
            inLabel = false
        }
        else if elementName == "Detail" {
            inDetail = false
        }
        else if elementName == "TaxonNames" {
            inTaxonNames = false
        }
        else if elementName == "TaxonName" {
            inTaxonName = false
            if inTaxonNames {
                dataset.items.append(currentItem!)
            }
        }
        else if elementName == "Characters" {
            inCharacters = false
        }
        else if elementName == "CategoricalCharacter" {
            inCategoricalCharacter = false
            if inCharacters {
                dataset.descriptors.append(currentDescriptor!)
            }
        }
        else if elementName == "QuantitativeCharacter" {
            inQuantitativeCharacter = false
            if inCharacters {
                dataset.descriptors.append(currentDescriptor!)
            }
        }
        else if elementName == "States" {
            inStates = false
        }
        else if elementName == "StateDefinition" {
            inStateDefinition = false
        }
            
        else if elementName == "CharacterTrees" {
            inCharacterTrees = false
        }
        else if elementName == "CharacterTree" {
            inCharacterTree = false
            if currentDescriptorDependencyTree != nil && isCharacterDependencyTree {
                dataset.descriptorTrees[.descriptorDependency] = currentDescriptorDependencyTree
            }
            else if currentDescriptorGroupTree != nil && isCharacterGroupTree {
                dataset.descriptorTrees[.descriptorGroup] = currentDescriptorGroupTree
            }
        }
        else if elementName == "Nodes" {
            inNodes = false
        }
        else if elementName == "Node" {
            inNode = false
            if inNodes && isCharacterGroupTree && (currentDescriptorGroupTree?.isGroupTree)! {
                currentDescriptorGroupTree?.addNode(currentGroupDescriptorNode!)
            }
        }
        else if elementName == "CharNode" {
            inCharNode = false
            if inNodes && isCharacterDependencyTree &&  currentDescriptorDependencyTree != nil &&
                (currentDescriptorDependencyTree?.isDependencyTree)! && currentDescriptorNode != nil && currentDescriptorNode?.object != nil{
                currentDescriptorDependencyTree?.addNode(currentDescriptorNode!)
            }
            else if inNodes && isCharacterGroupTree && (currentDescriptorGroupTree?.isGroupTree)! {
                currentDescriptorGroupTree?.addNode(currentDescriptorNode!)
            }
        }
        else if elementName == "Character" {
            inCharacter = false
        }
        else if elementName == "DependencyRules" {
            inDependencyRules = false
        }
        else if elementName == "InapplicableIf" {
            inInapplicableIf = false
        }
        else if elementName == "State" {
            inState = false
        }
            
        else if elementName == "MediaObjects" {
            inMediaObjects = false
        }
        else if elementName == "MediaObject" {
            inMediaObject = false
        }
        else if elementName == "TaxonHierarchies" {
            inTaxonHierarchies = false
        }
        else if elementName == "CodedDescriptions" {
            inCodedDescriptions = false
        }
        else if elementName == "CodedDescription" {
            inCodedDescription = false
            if inCodedDescriptions && itemsAreDefinedInCodedDescriptions {
                dataset.items.append(currentItem!)
                currentItem = nil
                currentlyDescribedItem = nil
                currentCodedDescriptionLabel = nil
            }
        }
        else if elementName == "SummaryData" {
            inSummaryData = false
        }
        else if elementName == "Categorical" {
            inCategorical = false
            if inSummaryData && inCodedDescription {
                let desc = currentItemDescription
                desc.descriptionElements[currentDescriptorUsedForDescription!] = currentDescriptionElementState
                currentItemDescription = desc
            }
        }
        else if elementName == "Quantitative" {
            inQuantitative = false
            if inSummaryData && inCodedDescription {
                let desc = currentItemDescription
                desc.descriptionElements[currentDescriptorUsedForDescription!] = currentDescriptionElementState
                currentItemDescription = desc
            }
        }
        else if elementName == "Measure" {
            inMeasure = false
        }
        else if elementName == "Scope" {
            inScope = false;
        }
        else if elementName == "Parent" {
            inParent = false
        }
        else if elementName == "DescriptiveConcepts" {
            inDescriptiveConcepts = false
        }
        else if elementName == "DescriptiveConcept" {
            inDescriptiveConcept = false
            if inDescriptiveConcepts  {
                currentDescriptorGroupTree?.addNode(currentGroupDescriptorNode!)
            }

        }
        else if elementName == "Type" {
            inType = false
        }
        else if elementName == "Source" {
            inSource = false
        }
        else if elementName == "Agents" {
            inAgents = false
        }
    }
    
    internal func parser(_ parser: XMLParser, foundCharacters string: String) {
        buffer = string
        
        if inDataset && isFirstDataset && inRepresentation && inLabel && !inTaxonNames && !inMediaObjects && !inDescriptiveConcepts && !inTaxonHierarchies  && !inCharacterTrees && !inCharacters && !inCodedDescriptions && !inAgents {
            if dataset.name == nil {
                dataset.name = ""
            }
            dataset.name! += string
        }
        else if inDetail {
            if inTaxonName {
                if currentItem?.detail != nil {
                    currentItem?.detail! += string
                }
                else {
                    currentItem?.detail = string
                }
            }
            else if (inCategoricalCharacter || inQuantitativeCharacter) && !inStates {
                if currentDescriptor?.detail != nil {
                    currentDescriptor?.detail! += string
                }
                else {
                    currentDescriptor?.detail = string
                }
            }
            else if inStateDefinition {
                if currentState?.detail != nil {
                    currentState?.detail! += string
                }
                else {
                    currentState?.detail = string
                }
            }
        }
        else if inLabel {
            if inTaxonName {
                currentItem?.name = string
            }
            else if (inCategoricalCharacter || inQuantitativeCharacter) && !inStates && !inMeasurementUnit {
                if currentDescriptor?.name == nil {
                    currentDescriptor?.name = ""
                }
                currentDescriptor?.name! += string
            }
            else if inQuantitativeCharacter && inMeasurementUnit {
                (currentDescriptor as! QuantitativeDescriptor).measurementUnit = string
            }
            else if inStateDefinition {
                if currentState?.name == nil {
                    currentState?.name = ""
                }
                currentState?.name = (currentState?.name)! + string
            }
            else if inMediaObject {
                currentResource?.name = string
            }
            else if inDescriptiveConcept {
                descriptiveConceptIdToNameDict[currentDescriptiveConceptId!] = string
            }
            else if inCodedDescription {
                if currentCodedDescriptionLabel == nil {
                    currentCodedDescriptionLabel =  ""
                }
                currentCodedDescriptionLabel = currentCodedDescriptionLabel! + string
            }
        }
        else if inType {
            if inMediaObject && currentResource != nil {
                currentResource?.type = ResourceType.fromString(string)
            }
        }
    }
    
    internal func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
//        NSLog("failure error: %@", parseError)
    }
}

private extension Dataset {
    func findStateById (_ id: String) -> State? {
        for descriptor in descriptors {
            if descriptor is CategoricalDescriptor {
                for state in (descriptor as! CategoricalDescriptor).states {
                    if state.id == id {
                        return state
                    }
                }
            }
        }
        return nil
    }
}



