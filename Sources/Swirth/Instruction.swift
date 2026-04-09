extension Swirth {
    enum Instruction {
        case push(Int)
        case dot
        case dup
        case add
        case divide
        case equal
        case notEqual
        case greaterThan
        case greaterThanOrEqual
        case lessThan
        case lessThanOrEqual
        case multiply
        case subtract
        case swap
        case drop
    }
}
