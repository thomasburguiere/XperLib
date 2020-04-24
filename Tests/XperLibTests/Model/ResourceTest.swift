import XCTest
@testable import XperLib

class ResourceTest: XCTestCase {
    func test_cannot_add_resource_directly_in_Resource_array() {

        var item = Item(id: "1")
        item.addResource(Resource(id:"1"))

        var resourcesRef: Array<Resource> = item.resources
        resourcesRef.append(Resource(id:"2"))

        XCTAssertEqual(resourcesRef.count, 2)
        XCTAssertEqual(item.resources.count, 1)
    }


    func test_can_add_resource() {

        var item = Item(id: "1")
        item.addResource(Resource(id:"1"))
        item.addResource(Resource(id:"2"))

        XCTAssertEqual(item.resources.count, 2)
        XCTAssertTrue(item.resources.first!.object as! Item == item)
    }

    func test_can_removed_resource() {

        var item = Item(id: "i1")
        let r1 = Resource(id: "r1")
        let r2 = Resource(id: "r2")

        item.addResource(r1)
        item.addResource(r2)

        item.removeResource(r1)

        XCTAssertEqual(item.resources.count, 1)
        XCTAssertTrue(item.resources.first!.object as! Item == item)
    }
}
