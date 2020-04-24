//
//  DatasetObjectWithResourceTest.swift
//  Xper
//
//  Created by Thomas Burguiere on 05/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

import XCTest
@testable import XperLib

class DatasetObjectWithResourceTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_addResource() {
        var d = Descriptor(id:"d1", name: "de")
        let r = Resource(id: "r1")
        d.addResource(r)
        
        XCTAssertNotNil(r.object)
        XCTAssertTrue(r.object! is Descriptor)
        XCTAssertTrue(r.object! as! Descriptor === d)
    }
    
    func test_addResources() {
        var d = Descriptor(id:"d1", name: "de")
        let r1 = Resource(id: "r1")
        let r2 = Resource(id: "r2")
        d.addResources([r1, r2])
        
        XCTAssertTrue(r1.object != nil)
        XCTAssertTrue(r1.object! is Descriptor)
        XCTAssertTrue(r1.object! as! Descriptor === d)
        
        XCTAssertNotNil(r2.object)
        XCTAssertTrue(r2.object! is Descriptor)
        XCTAssertTrue(r2.object! as! Descriptor === d)
    }
    
    func test_removeResource_removes_resource_if_it_was_found() {
        var d = Descriptor(id:"d1", name: "de")
        let r = Resource(id: "r1")
        d.addResource(r)
        
        d.removeResource(r)
        XCTAssertNil(r.object)
        XCTAssertTrue(d.resources.isEmpty)
    }
    
    func test_removeResource_doesnt_remove_resource_if_it_was_found() {
        //given
        var d = Descriptor(id:"d1", name: "de")
        let r1 = Resource(id: "r1")
        let r2 = Resource(id: "r1")
        d.addResource(r1)
        d.addResource(r2)
        
        //when
        d.removeResource(r2)
        
        //then
        XCTAssertNotNil(r1.object)
        XCTAssertNil(r2.object)
        XCTAssertTrue(d.resources.count == 1)
    }
    
    func test_removeAllResources_works() {
        //given
        var d = Descriptor(id:"d1", name: "de")
        let r1 = Resource(id: "r1")
        let r2 = Resource(id: "r1")
        d.addResource(r1)
        d.addResource(r2)
        
        //when
        d.removeAllResources()
        
        //then
        XCTAssertNil(r1.object)
        XCTAssertNil(r2.object)
        XCTAssertTrue(d.resources.isEmpty )
    }
}
