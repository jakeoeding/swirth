extension Swirth {
    enum BoolFlag: Int {
        case `true` = -1
        case `false` = 0

        static func from(_ value: Bool) -> Self {
            value ? .true : .false
        }
    }

    enum Literal {
        case int(Int)
        case bool(BoolFlag)
    }

    enum Word {
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

    enum Delimiter {
        case functionStart
        case functionEnd
    }

    enum Token {
        case literal(Literal)
        case word(Word)
        case delimiter(Delimiter)
        case identifier(String)
    }
}
