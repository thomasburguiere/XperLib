import XCTest
@testable import XperLib

class DatasetTest: XCTestCase {
    func test_find_descriptor_by_name() {

        let dataset = Dataset(name: "ds")
        dataset.descriptors.append(Descriptor(id: "1", name: "desc1"))
        dataset.descriptors.append(Descriptor(id: "2", name: "desc2"))

        let actual: Descriptor? = dataset.getDescriptorByName("desc1")
        XCTAssertEqual(actual?.name, "desc1");

        let absent: Descriptor? = dataset.getDescriptorByName("toto")
        XCTAssertNil(absent);
    }
}
