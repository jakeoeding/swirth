extension Swirth {
    enum BoolFlag: Int {
        case `true` = -1
        case `false` = 0

        static func from (_ value: Bool) -> Self {
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
        case greaterThan
        case greaterThanOrEqual
        case lessThan
        case lessThanOrEqual
        case multiply
        case subtract
        case swap
    }

    enum Token {
        case literal(Literal)
        case word(Word)
    }

    struct Lexer {
        enum LexingError: Error {
            case unexpectedToken(String)
        }

        static func tokenize(_ input: String) throws(LexingError) -> [Token] {
            try input
                .split(whereSeparator: \.isWhitespace)
                .map { value throws(LexingError) in
                    let str = String(value)

                    if str == "." {
                        return .word(.dot)
                    } else if str == "dup" {
                        return .word(.dup)
                    } else if str == "+" {
                        return .word(.add)
                    } else if str == "/" {
                        return .word(.divide)
                    } else if str == "=" {
                        return .word(.equal)
                    } else if str == ">" {
                        return .word(.greaterThan)
                    } else if str == ">=" {
                        return .word(.greaterThanOrEqual)
                    } else if str == "<" {
                        return .word(.lessThan)
                    } else if str == "<=" {
                        return .word(.lessThanOrEqual)
                    } else if str == "*" {
                        return .word(.multiply)
                    } else if str == "-" {
                        return .word(.subtract)
                    } else if str == "swap" {
                        return .word(.swap)
                    } else if str == "true" {
                        return .literal(.bool(.true))
                    } else if str == "false" {
                        return .literal(.bool(.false))
                    } else if let i = Int(str) {
                        return .literal(.int(i))
                    } else {
                        throw .unexpectedToken(str)
                    }
                }
        }
    }
}
