import XCTest
@testable import XperLib

class CheckDatasetServiceTest: XCTestCase {

    let service: CheckDatasetService = CheckDatasetService()

    func test_find_itemsWithSameDescription() {

        let dataset = Dataset(name: "ds")

        let skinColor: CategoricalDescriptor = CategoricalDescriptor(id: "skinColor", name: "skinColor")
        let white = State(id: "white", name: "white")
        let grey = State(id: "grey", name: "grey")
        let black = State(id: "black", name: "black")
        skinColor.addStates(states: [white, black, grey])

        let weight: QuantitativeDescriptor = QuantitativeDescriptor(id: "weight", name: "weight")
        weight.measurementUnit = "Kg"

        let elephant1 = Item(id: "elephant1")
        elephant1.describe(forDescriptor: skinColor, selectedStates: [grey])
        elephant1.describe(forDescriptor: weight, measure: QuantitativeMeasure(mean: 4000))

        let elephant2 = Item(id: "elephant2")
        elephant2.describe(forDescriptor: skinColor, selectedStates: [grey])
        elephant2.describe(forDescriptor: weight, measure: QuantitativeMeasure(mean: 4000))

        let mouse = Item(id: "mouse")
        mouse.describe(forDescriptor: skinColor, selectedStates: [white])
        mouse.describe(forDescriptor: weight, measure: QuantitativeMeasure(mean: 0.15))

        let rat = Item(id: "rat")
        rat.describe(forDescriptor: skinColor, selectedStates: [black, grey])
        rat.describe(forDescriptor: weight, measure: QuantitativeMeasure(mean: 0.3))

        dataset.items = [elephant1, elephant2, rat, mouse]


        let itemsWithSameDescriptions: Dictionary<Description, Array<Item>> = service.getItemsWithSameDescription(dataset: dataset)
        XCTAssertEqual(itemsWithSameDescriptions.keys.count, 1)

        var elephantsHaveSameDescriptions = false
        for (_, items) in itemsWithSameDescriptions {
            if items.contains(elephant2) && items.contains(elephant1) {
                elephantsHaveSameDescriptions = true
            }
        }
        XCTAssertTrue(elephantsHaveSameDescriptions, "expected elephantsHaveSameDescriptions to be true")
    }
}
