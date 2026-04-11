public struct Lexer {
    public static func tokenize(_ input: String) throws(LexingError) -> [Token] {
        var tokens = [Token]()
        var commentMode = false

        for value in input.split(whereSeparator: \.isWhitespace) {
            let str = String(value)

            if str == "(" {
                commentMode = true
                continue
            }

            if commentMode && str == ")" {
                commentMode = false
                continue
            }

            if commentMode {
                continue
            }

            if str == "." {
                tokens.append(.word(.dot))
            } else if str == "dup" {
                tokens.append(.word(.dup))
            } else if str == "+" {
                tokens.append(.word(.add))
            } else if str == "/" {
                tokens.append(.word(.divide))
            } else if str == "=" {
                tokens.append(.word(.equal))
            } else if str == "<>" {
                tokens.append(.word(.notEqual))
            } else if str == ">" {
                tokens.append(.word(.greaterThan))
            } else if str == ">=" {
                tokens.append(.word(.greaterThanOrEqual))
            } else if str == "<" {
                tokens.append(.word(.lessThan))
            } else if str == "<=" {
                tokens.append(.word(.lessThanOrEqual))
            } else if str == "*" {
                tokens.append(.word(.multiply))
            } else if str == "-" {
                tokens.append(.word(.subtract))
            } else if str == "swap" {
                tokens.append(.word(.swap))
            } else if str == "drop" {
                tokens.append(.word(.drop))
            } else if str == "lshift" {
                tokens.append(.word(.lshift))
            } else if str == "rshift" {
                tokens.append(.word(.rshift))
            } else if str == "max" {
                tokens.append(.word(.max))
            } else if str == "min" {
                tokens.append(.word(.min))
            } else if str == "true" {
                tokens.append(.literal(.bool(.true)))
            } else if str == "false" {
                tokens.append(.literal(.bool(.false)))
            } else if str == ":" {
                tokens.append(.delimiter(.functionStart))
            } else if str == ";" {
                tokens.append(.delimiter(.functionEnd))
            } else if let i = Int(str) {
                tokens.append(.literal(.int(i)))
            } else {
                tokens.append(.identifier(str))
            }
        }

        if commentMode {
            throw .unterminatedComment
        }

        return tokens
    }
}

extension Lexer {
    public enum LexingError: Error {
        case unterminatedComment
    }
}
