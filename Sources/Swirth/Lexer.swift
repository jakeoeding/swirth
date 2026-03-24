extension Swirth {
    enum Operation {
        enum Unary {
            case dot
            case dup
        }

        enum Binary {
            case add
            case divide
            case multiply
            case subtract
        }

        case unary(Unary)
        case binary(Binary)
    }

    enum ForthToken {
        case literal(Int)
        case operation(Operation)
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
                        return .operation(.unary(.dot))
                    } else if str == "dup" {
                        return .operation(.unary(.dup))
                    } else if str == "+" {
                        return .operation(.binary(.add))
                    } else if str == "/" {
                        return .operation(.binary(.divide))
                    } else if str == "*" {
                        return .operation(.binary(.multiply))
                    } else if str == "-" {
                        return .operation(.binary(.subtract))
                    } else if let i = Int(str) {
                        return .literal(i)
                    } else {
                        throw LexingError.unexpectedToken(str)
                    }
                }
        }
    }
}
