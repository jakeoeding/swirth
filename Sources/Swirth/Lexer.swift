extension Swirth {
    enum Operation {
        case add
        case dot
    }

    enum ForthToken {
        case literal(value: Int)
        case operation(word: Operation)
    }

    struct Lexer {
        enum LexingError: Error {
            case unexpectedToken(String)
        }

        static func process(_ input: String) throws -> [ForthToken] {
            try input
                .split(whereSeparator: \.isWhitespace)
                .map { value in
                    let str = String(value)

                    if str == "+" {
                        return .operation(word: .add)
                    } else if str == "." {
                        return .operation(word: .dot)
                    } else if let i = Int(str) {
                        return .literal(value: i)
                    } else {
                        throw LexingError.unexpectedToken(str)
                    }
                }
        }
    }
}
