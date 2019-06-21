import UIKit

extension String {
    var isNumeric: Bool {
        guard let _ = self.rangeOfCharacter(from: .decimalDigits) else { return false }
        return true
    }
    
    var lines: Int {
        let components = self.components(separatedBy: .newlines)
        return components.count
    }

    func withPrefix(_ prefix: String) -> String {
        guard !self.hasPrefix(prefix) else { return self }
        return prefix + self
    }
}

"pet".withPrefix("car")

let linesTestString = "this\nis\na\ntest\nwow"
linesTestString.lines

"Class1".isNumeric
"ClassC".isNumeric
