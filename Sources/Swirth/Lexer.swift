extension Swirth {
    enum BoolFlag: Int {
        case `true` = -1
        case `false` = 0
    }

    enum Literal {
        case int(Int)
        case bool(BoolFlag)
    }

    enum Word {
        enum Unary {
            case dot
            case dup
        }

        enum Binary {
            case add
            case divide
            case multiply
            case subtract
            case swap
        }

        case unary(Unary)
        case binary(Binary)
    }

    enum ForthToken {
        case literal(Literal)
        case word(Word)
    }

    struct Lexer {
        enum LexingError: Error {
            case unexpectedToken(String)
        }

        static func tokenize(_ input: String) throws -> [ForthToken] {
            try input
                .split(whereSeparator: \.isWhitespace)
                .map { value in
                    let str = String(value)

                    if str == "." {
                        return .word(.unary(.dot))
                    } else if str == "dup" {
                        return .word(.unary(.dup))
                    } else if str == "+" {
                        return .word(.binary(.add))
                    } else if str == "/" {
                        return .word(.binary(.divide))
                    } else if str == "*" {
                        return .word(.binary(.multiply))
                    } else if str == "-" {
                        return .word(.binary(.subtract))
                    } else if str == "swap" {
                        return .word(.binary(.swap))
                    } else if str == "true" {
                        return .literal(.bool(.true))
                    } else if str == "false" {
                        return .literal(.bool(.false))
                    } else if let i = Int(str) {
                        return .literal(.int(i))
                    } else {
                        throw LexingError.unexpectedToken(str)
                    }
                }
        }
    }
}
