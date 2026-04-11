public enum Token: Sendable, Equatable {
    case literal(Literal)
    case word(Word)
    case delimiter(Delimiter)
    case identifier(String)
}

public enum Literal: Sendable, Equatable {
    case int(Int)
    case bool(BoolFlag)
}

public enum BoolFlag: Int, Sendable, Equatable {
    case `true` = -1
    case `false` = 0

    static func from(_ value: Bool) -> Self {
        value ? .true : .false
    }
}

public enum Word: Sendable, Equatable {
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
    case lshift
    case rshift
    case max
    case min
}

public enum Delimiter: Sendable, Equatable {
    case functionStart
    case functionEnd
}
