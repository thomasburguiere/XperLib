public class CheckDatasetService {

    func getItemsWithSameDescription(dataset: Dataset) -> Dictionary<Description, Array<Item>> {
        var itemsWithSameDescription = Dictionary<Description, Array<Item>>()
        for item in dataset.items {
            if let itemDescription = item.itemDescription {

                if var items: Array<Item> = itemsWithSameDescription[itemDescription] {
                    items.append(item)
                    itemsWithSameDescription.updateValue(items, forKey: itemDescription)
                } else {
                    itemsWithSameDescription.updateValue([item], forKey: itemDescription)
                }
            }
        }
        var filtered = Dictionary<Description, Array<Item>>()
        for (description, items) in itemsWithSameDescription {
            if items.count > 1 {
                filtered.updateValue(items, forKey: description)
            }
        }
        return filtered
    }

    func getErroneousDescription(dataset: Dataset) {
        var erroneousDescriptions = Array<ErroneousDescription>()
        for item: Item in dataset.items {
            for (descriptor, des) in item.itemDescription!.descriptionElements {
                if des.isDescribed && des.unknown {
                    let description = ErroneousDescription(item, descriptor, des)
                    erroneousDescriptions.append(description)
                }
            }
        }
    }

    public class ErroneousDescription {
        public let item: Item
        public let descriptor: Descriptor
        public let description: DescriptionElementState

        init(_ item: Item, _ descriptor: Descriptor, _ description: DescriptionElementState) {
            self.item = item
            self.descriptor = descriptor
            self.description = description
        }
    }

}

public enum ReportItem {
    case Full
    case Descriptors
    case Descriptions
}
