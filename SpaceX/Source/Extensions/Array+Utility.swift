
import Foundation

extension Array {
    
    //Convenience to access elements when unsure of the size of `self`
    func at(_ index: Int) -> Element? {
        guard
            !self.isEmpty && self.indices.contains(index)
            else { return nil }
        return self[index]
    }
}

public extension Array where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

public extension Array where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(Int(total)) / Double(count)
    }
}

public extension Array where Element: FloatingPoint {
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
