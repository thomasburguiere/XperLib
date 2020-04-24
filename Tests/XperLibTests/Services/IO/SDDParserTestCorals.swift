//
//  XperLibTests.swift
//  XperLibTests
//
//  Created by Thomas Burguiere on 09/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import XCTest
@testable import XperLib

class SDDParserTestCorals: XCTestCase {
    
    var nsxmlParsedGenetsDataset: Dataset?
    
    //MARK: setup functions

    fileprivate func initializeNsxmlDatasetForSddFile(_ sddFileName: String) -> Dataset {
        if nsxmlParsedGenetsDataset == nil {
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/corals.sdd.xml"))
            
            let parser = SddNSXMLParser()
            nsxmlParsedGenetsDataset = parser.parseDataset(fileData)
        }
        return nsxmlParsedGenetsDataset!
    }
    
    
    //MARK: Item parsing sanity checks
    

    
    func skipped_test_nsxml_parsing_extracts_items_correctly_corals () {
        let dataset = initializeNsxmlDatasetForSddFile("corals")
        XCTAssertEqual(dataset.name, "Corals")
        
        XCTAssertEqual(dataset.items.count, 53)
        let t2Item = dataset.items.filter{$0.id == "t2"}.first!
        
        XCTAssertNotNil(t2Item)
        
        XCTAssertEqual(t2Item.name, "Pocilloporidae Seriatopora")
        XCTAssertEqual(t2Item.detail, "Proche du genre Stylophora, avec cependant une distribution des calices alignés en files longitudinales et la présence d'une seule cloison septale atteignant la columelle. Une seule espèce* en milieu protégé de la houle(lagon, pente externe profonde).<br><br>* Seriatopora hystrix")
        
        XCTAssertEqual(t2Item.resources.count, 9)
        XCTAssertEqual(t2Item.resources.first!.id, "m242")
        XCTAssertEqual(t2Item.resources.first!.name, "Seriatopora - m35")
        XCTAssertEqual(t2Item.resources.first!.url!, "http://docbrown.snv.jussieu.fr/images_mascarenes/illus-genres-tous/Seriatopora-sp/seriatopora9912.JPG")
        XCTAssertEqual(t2Item.resources.first!.type, ResourceType.image)
        
        
    }
    
    //MARK: Descriptor parsing sanity checks
    
    
    func skipped_test_nsxml_parsing_extracts_descriptors_correctly_corals () {
        let dataset = initializeNsxmlDatasetForSddFile("corals")
        XCTAssertEqual(dataset.name, "Corals")
        
        XCTAssertEqual(dataset.descriptors.count, 8)
        
        let c2Descriptor = dataset.descriptors.filter{$0.id == "c2"}.first!
        XCTAssertNotNil(c2Descriptor.id)
        XCTAssertEqual(c2Descriptor.name, "Relationship between corallites?")
        XCTAssertEqual(c2Descriptor.detail, "<b>How corallites are arranged?</b><br>Click on the different states (in the window states at the bottom left) to see their definitions and illustrations. Read carefully the definitions.<br><br>Some colony may include several different states. For example: ploicid and ceriod, phaceloid and flabello-meandroid, ect.<br>On illustration, mauve calque shows the mouths (corallites)")
        
        XCTAssertEqual(c2Descriptor.resources.count, 11)
        
        let m54Resource =  c2Descriptor.resources.filter{$0.id == "m54"}.first!
        XCTAssertNotNil(m54Resource)
        XCTAssertEqual(m54Resource.name, "plocoid - m818")
        XCTAssertEqual(m54Resource.url!, "http://docbrown.snv.jussieu.fr/images_mascarenes/agencementdescalices/separenonjointif.jpg")
        XCTAssertEqual(m54Resource.type, ResourceType.image)
        
        let c2CategoricalDesc = c2Descriptor as! CategoricalDescriptor
        XCTAssertEqual(c2CategoricalDesc.states.count, 12)
        
        let s21State = c2CategoricalDesc.states.filter{$0.id == "s21"}.first!
        XCTAssertNotNil(s21State)
        XCTAssertEqual(s21State.name, "fungioid")
        XCTAssertEqual(s21State.detail, "Corallites centers are irregularly or regulary distributed on the colony and linked by septa elements. Sometimes some corallites centers are gathered in central dimple.<br>The wall is present but invisible on the higher face of the colony, and only visible on the lower face.")
        
        XCTAssertEqual(s21State.resources.count, 4)
        XCTAssertEqual(s21State.resources.first!.id, "m110")
        XCTAssertEqual(s21State.resources.first!.name, "fungioid - m874")
        XCTAssertEqual(s21State.resources.first!.url!, "http://docbrown.snv.jussieu.fr/images_mascarenes/illus-genres-tous/Herpolitha-sp/herpolita-skelton.jpg")
        XCTAssertEqual(s21State.resources.first!.type, ResourceType.image)
    }
    
    
    
   }
