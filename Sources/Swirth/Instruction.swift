extension Swirth {
    enum Instruction {
        case push(Int)
        case dot
        case dup
        case add
        case divide
        case equal
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
