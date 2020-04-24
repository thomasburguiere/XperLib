//
//  SDDParserTestFeuilles.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 26/05/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import XCTest
@testable import XperLib

class SDDParserTestFeuilles: XCTestCase {
    
    var nsxmlParsedGenetsDataset: Dataset?
    
    //MARK: setup functions

    fileprivate func initializeNsxmlDatasetForSddFile(_ sddFileName: String) -> Dataset {
        if nsxmlParsedGenetsDataset == nil {
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/feuillesImagesURL.sdd"))
            
            let parser = SddNSXMLParser()
            nsxmlParsedGenetsDataset = parser.parseDataset(fileData)
        }
        return nsxmlParsedGenetsDataset!
    }
    
    func skipped_test_names_are_extracted_correctly () {
        let dataset = initializeNsxmlDatasetForSddFile("feuillesImagesURL")
        
        XCTAssertEqual(dataset.name, "Description détaillée des Feuilles des arbres")
        
        XCTAssertEqual(dataset.items[0].name, "Arbre de Judée")
        
        let nervation = dataset.descriptors.filter({$0.name == "Nervation"}).first as! CategoricalDescriptor
        XCTAssertEqual(nervation.states.first?.name, "nervation pennée (nervure primaire unique prolongeant le pétiole)")
    }
}
