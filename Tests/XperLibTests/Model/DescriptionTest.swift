//
//  DescriptionTest.swift
//  Xper
//
//  Created by Thomas Burguiere on 11/03/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import XCTest
@testable import XperLib

class DescriptionTest: XCTestCase {

    func test_empty_quantitative_measure_are_equal() {
        let qm1 = QuantitativeMeasure()
        let qm2 = QuantitativeMeasure()

        XCTAssertTrue(qm1 == qm2)
    }

    func test_one_non_empty_quantitative_measure_are_not_equal() {
        let qm1 = QuantitativeMeasure()
        qm1.mean = 3.0
        let qm2 = QuantitativeMeasure()

        XCTAssertFalse(qm1 == qm2)
    }


    func test_two_non_empty_quantitative_measure_with_different_mean_are_not_equal() {
        let qm1 = QuantitativeMeasure()
        qm1.mean = 3.0
        let qm2 = QuantitativeMeasure()
        qm2.mean = 3.1

        XCTAssertFalse(qm1 == qm2)
    }

    func test_two_non_empty_quantitative_measure_with_same_mean_are_not_equal() {
        let qm1 = QuantitativeMeasure()
        qm1.mean = 3.0
        let qm2 = QuantitativeMeasure()
        qm2.mean = 3.0

        XCTAssertTrue(qm1 == qm2)
    }

    func test_empty_description_element_is_not_described() {
        let des = DescriptionElementState()
        XCTAssertFalse(des.isDescribed)
    }

    func test_empty_description_element_are_equal() {
        let des1 = DescriptionElementState()
        let des2 = DescriptionElementState()

        XCTAssertTrue(des1 == des2)
    }

    func test_two_non_empty_description_element_are_equal() {
        let des1 = DescriptionElementState()
        des1.quantitativeMeasure = QuantitativeMeasure()
        let des2 = DescriptionElementState()
        des2.quantitativeMeasure = QuantitativeMeasure()

        XCTAssertTrue(des1 == des2)
    }

    func test_one_non_empty_description_element_are_not_equal() {
        let des1 = DescriptionElementState()
        let des2 = DescriptionElementState()
        des2.quantitativeMeasure = QuantitativeMeasure()

        XCTAssertFalse(des1 == des2)
    }

    func test_description_element_with_different_quantitative_measures_are_not_equal() {
        let des1 = DescriptionElementState()
        let qm1: QuantitativeMeasure = QuantitativeMeasure()
        qm1.mean = 3.4
        des1.quantitativeMeasure = qm1

        let des2 = DescriptionElementState()
        let qm2: QuantitativeMeasure = QuantitativeMeasure()
        qm2.mean = 3.5
        des2.quantitativeMeasure = qm2

        XCTAssertFalse(des1 == des2)
    }


    func test_description_element_with_same_quantitative_measures_are_equal() {
        let des1 = DescriptionElementState()
        let qm1: QuantitativeMeasure = QuantitativeMeasure()
        qm1.mean = 3.5
        des1.quantitativeMeasure = qm1

        let des2 = DescriptionElementState()
        let qm2: QuantitativeMeasure = QuantitativeMeasure()
        qm2.mean = 3.5
        des2.quantitativeMeasure = qm2

        XCTAssertTrue(des1 == des2)
    }

    func test_description_element_with_same_selectedStates_are_equal() {

        let s1 = State(id:"s", name: "s")
        let s2 = State(id:"s", name: "s")

        let des1 = DescriptionElementState()
        des1.selectedStates.append(s1)

        let des2 = DescriptionElementState()
        des2.selectedStates.append(s2)

        XCTAssertTrue(des1 == des2)
    }
    
    func test_description_with_categorical_is_complete() {
        let description = Description()
        let descriptor = CategoricalDescriptor(id:"descriptor", name: "de")
        descriptor.states = [State(id:"a", name: "de"), State(id:"b", name: "de")]
        
        let des = DescriptionElementState()
        des.selectedStates = []
        description.descriptionElements = [descriptor:des]
        XCTAssertFalse(description.isDescriptionComplete())
        
        des.selectedStates.append(State(id:"c", name: "de"))
        XCTAssertTrue(description.isDescriptionComplete())
        
    }
    
    func test_description_with_quantitative_is_complete() {
        let description = Description()
        let descriptor = QuantitativeDescriptor(id:"descriptor", name: "de")
        
        let qm = QuantitativeMeasure()
        
        
        
        let des = DescriptionElementState()
        des.quantitativeMeasure = qm
        description.descriptionElements = [descriptor:des]
        XCTAssertFalse(description.isDescriptionComplete())
        
        qm.max = 2.0
        qm.min = 1.0
        XCTAssertTrue(description.isDescriptionComplete())
    }
        
    func test_description_with_unknown_is_complete() {
        let description = Description()
        let descriptor = QuantitativeDescriptor(id:"descriptor", name: "de")
        
        let qm = QuantitativeMeasure()
                
        let des = DescriptionElementState()
        des.quantitativeMeasure = qm
        description.descriptionElements = [descriptor:des]
        XCTAssertFalse(description.isDescriptionComplete())
        
        des.unknown = true
        XCTAssertTrue(description.isDescriptionComplete())
    }
    
    
    func test_description_removeState_works() {
        let description = Description()
        let descriptor = CategoricalDescriptor(id:"descriptor", name: "de")
        let stateA = State(id:"a", name: "A")
        descriptor.states = [stateA, State(id:"b", name: "B")]
        
        let des = DescriptionElementState()
        des.selectedStates = [stateA]
        description.descriptionElements = [descriptor:des]
        
        XCTAssertTrue(description.descriptionElements[descriptor]!.selectedStates.count == 1)
        description.removeState(stateA, forDescriptor: descriptor)
        
        XCTAssertTrue(description.descriptionElements[descriptor]!.selectedStates.count == 0)
    }
    
    func test_description_removeState_does_not_delete_worngfully() {
        let description = Description()
        let descriptor = CategoricalDescriptor(id:"descriptor", name: "de")
        let stateA = State(id:"a", name: "A")
        descriptor.states = [stateA, State(id:"b", name: "B")]
        
        let des = DescriptionElementState()
        des.selectedStates = [stateA]
        description.descriptionElements = [descriptor:des]
        
        XCTAssertTrue(description.descriptionElements[descriptor]!.selectedStates.count == 1)
        description.removeState(State(id:"A", name: "A"), forDescriptor: descriptor)
        
        XCTAssertTrue(description.descriptionElements[descriptor]!.selectedStates.count == 1)
    }

}
