//
//  DescriptorTest.swift
//  XperFramework
//
//  Created by Thomas Burguiere on 14/04/16.
//  Copyright © 2016 Thomas Burguiere. All rights reserved.
//

import Foundation

import XCTest
@testable import XperLib

class DescriptorTest: XCTestCase {
    func test_that_constructor_works() {

        let actual = Descriptor(id: "1", name: "descriptor")
        XCTAssertEqual(actual.name, "descriptor")
    }

    func test_should_create_discrete_descriptor_with_states() {
        let actual = CategoricalDescriptor(id: "1", name: "discreteDescriptor")


        XCTAssertEqual(actual.name, "discreteDescriptor")
        XCTAssertTrue(actual.getStates().count == 0)

        actual.addState(state: State(id: "1", name: "state"))
        XCTAssertTrue(actual.getStates().count == 1)
        XCTAssertEqual(actual.getStates().first?.name, "state")
    }

    func test_inequality() {
        let d1 = CategoricalDescriptor(id: "1", name: "d1")
        let d2 = CategoricalDescriptor(id: "2", name: "d2")

        XCTAssertFalse(d1 == d2)
    }

    func test_equality() {
        let d1 = CategoricalDescriptor(id: "1", name: "d1")
        let d2 = CategoricalDescriptor(id: "1", name: "d1")

        XCTAssertTrue(d1 == d2)
    }

    func test_Continuous_and_Discrete_descriptor_are_inequal() {
        let d1 = CategoricalDescriptor(id: "1", name: "d1")
        let d2 = QuantitativeDescriptor(id: "1", name: "d1")

        XCTAssertFalse(d1 == d2)
    }

    func test_Continuous_descriptors_with_different_units_are_not_equal() {
        let d1 = QuantitativeDescriptor(id: "1", name: "d1")
        let d2 = QuantitativeDescriptor(id: "1", name: "d1")

        // when
        d1.measurementUnit = "cm"
        d2.measurementUnit = "mm"

        // then
        XCTAssertFalse(d1 == d2)


        // when
        d1.measurementUnit = nil
        d2.measurementUnit = "mm"

        // then
        XCTAssertFalse(d1 == d2)
    }

    func test_Continuous_descriptors_same_units_are_equal() {
        let d1 = QuantitativeDescriptor(id: "1", name: "d1")
        let d2 = QuantitativeDescriptor(id: "1", name: "d1")

        // when
        d1.measurementUnit = "cm"
        d2.measurementUnit = "cm"

        // then
        XCTAssertTrue(d1 == d2)
    }

    func test_Discrete_descriptors_with_different_states_are_not_equal() {
        let d1 = CategoricalDescriptor(id: "1", name: "d1")
        let d2 = CategoricalDescriptor(id: "1", name: "d1")

        // when
        d1.addState(state: State(id: "1", name: "s1"))
        d2.addState(state: State(id: "2", name: "s2"))

        // then
        XCTAssertFalse(d1 == d2)
    }

    func test_Discrete_descriptors_with_same_states_are_equal() {
        let d1 = CategoricalDescriptor(id: "1", name: "d1")
        let d2 = CategoricalDescriptor(id: "1", name: "d1")

        // when
        let s1 = State(id: "1", name: "s1")
        let s2 = State(id: "1", name: "s1")
        d1.addState(state: s1)
        d2.addState(state: s2)

        // then
        XCTAssertTrue(d1 == d2)
        XCTAssertTrue(s1 == s2)
    }


    func test_that_Descriptor_isQuantitative_works() {
        let qd = QuantitativeDescriptor(id:"idc")
        let cd = CategoricalDescriptor(id:"idq")
        
        XCTAssertTrue(qd.isQuantitative)
                XCTAssertFalse(cd.isQuantitative)
    }
    
    func test_that_Descriptor_isCategorical_works() {
        let qd = QuantitativeDescriptor(id:"idq")
        let cd = CategoricalDescriptor(id:"idc")
        
        XCTAssertTrue(cd.isCategorical)
        XCTAssertFalse(qd.isCategorical)
    }
    
    func test_that_equals_returns_true_for_quantitatives_with_same_id_and_same_unit() {
        let qd1 = QuantitativeDescriptor(id:"idq")
        let qd2 = QuantitativeDescriptor(id:"idq")
        
        qd1.measurementUnit = "cm"
        qd2.measurementUnit = "cm"
        XCTAssertTrue(qd1 == qd2)
    }
    
    func test_that_equals_returns_false_for_quantitatives_with_different_ids_and_same_unit() {
        let qd1 = QuantitativeDescriptor(id:"idq1")
        let qd2 = QuantitativeDescriptor(id:"idq2")
        
        qd1.measurementUnit = "cm"
        qd2.measurementUnit = "cm"
        XCTAssertFalse(qd1 == qd2)
    }
    
    func test_that_equals_returns_false_for_quantitatives_with_same_id_and_different_unit() {
        let qd1 = QuantitativeDescriptor(id:"idq")
        let qd2 = QuantitativeDescriptor(id:"idq")
        
        qd1.measurementUnit = "cm"
        qd2.measurementUnit = "mm"
        XCTAssertFalse(qd1 == qd2)
    }
    
    func test_that_equals_returns_false_for_one_quantitative_and_one_categorical() {
        let qd = QuantitativeDescriptor(id:"id")
        let cd = CategoricalDescriptor(id:"id")
        XCTAssertFalse(qd == cd)
    }
    
    func test_that_equals_returns_true_for_categoricals_with_same_id_and_same_states() {
        let state1 = State(id:"s1")
        let state2 = State(id:"s2")
        let state3 = State(id:"s3")
        
        let cd1 = CategoricalDescriptor(id:"idc")
        cd1.states = [state1, state2, state3]
        
        let cd2 = CategoricalDescriptor(id:"idc")
        cd2.states = [state1, state2, state3]

        
        XCTAssertTrue(cd1 == cd2)
    }
    
    func test_that_equals_returns_false_for_categoricals_with_same_id_and_different_states() {
        let state1 = State(id:"s1")
        let state2 = State(id:"s2")
        let state3 = State(id:"s3")
        
        let cd1 = CategoricalDescriptor(id:"idc")
        cd1.states = [state1, state2]
        
        let cd2 = CategoricalDescriptor(id:"idc")
        cd2.states = [state1, state2, state3]
        
        
        XCTAssertFalse(cd1 == cd2)
    }
}
