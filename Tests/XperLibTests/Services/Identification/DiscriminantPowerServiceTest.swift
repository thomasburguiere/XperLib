//
//  DiscriminantPowerServiceTest.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 06/05/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import XCTest
@testable import XperLib

class DiscriminantPowerServiceTest: XCTestCase {
    var nsxmlParsedGenetsDataset: Dataset?
    
    //MARK: setup functions
    fileprivate func getSddTestFileLocation(_ fileName: String) -> String? {
        let testBundle = Bundle(for: type(of: self))
        return testBundle.path(forResource: fileName, ofType: "sdd.xml")
    }
    
    fileprivate func initializeNsxmlDatasetForSddFile(_ sddFileName: String) -> Dataset {
        if nsxmlParsedGenetsDataset == nil {
            let fileData = try? Data(contentsOf: URL(fileURLWithPath: getSddTestFileLocation(sddFileName)!))
            
            let parser = SddNSXMLParser()
            nsxmlParsedGenetsDataset = parser.parseDataset(fileData)
        }
        return nsxmlParsedGenetsDataset!
    }
    
    
    func skip_test_should_compute_DP_without_crashing_for_genetta(){
        let currentBundle = Bundle(for: type(of: self))
        let realBundle = Bundle(path: "\(currentBundle.bundlePath)/../../../../Tests/XperLibTests/Resources")
        
        
        let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/genetta.sdd.xml"))
        
        let parser = SddNSXMLParser()
        let dataset =  parser.parseDataset(fileData)!
        
        XCTAssertEqual(dataset.name, "Genets")
        
        var result = Dictionary<String, Double>()
        for descriptor in dataset.descriptors {
            result[descriptor.name!] = DiscriminantPowerService.getDiscriminantPower(descriptor: descriptor, items: dataset.items, value: 0, scoreMethod: .xper, dependencyTree: dataset.descriptorTrees[TreeType.descriptorDependency]!, considerChildScores: true, withGlobalWeights: false)
        }
        
        print(result)
    }

    func skip_test_should_compute_DP_without_crashing_for_corals(){
        let fileData = try? Data(contentsOf: URL(fileURLWithPath: "./Tests/XperLibTests/Resources/corals.sdd.xml"))
        
        let parser = SddNSXMLParser()
        let dataset =  parser.parseDataset(fileData)!
        
        XCTAssertEqual(dataset.name, "Corals")
        var result = [Descriptor: Double]()
        for descriptor in dataset.descriptors {
            result[descriptor] = DiscriminantPowerService.getDiscriminantPower(descriptor: descriptor, items: dataset.items, value: 0, scoreMethod: .xper, dependencyTree: dataset.descriptorTrees[TreeType.descriptorDependency]!, considerChildScores: true, withGlobalWeights: false)
        }
        print(result)
       
    }
}
