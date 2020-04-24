public class XperError: Error {
    public let message: String

    init(message: String) {
        self.message = message
    }
}