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

    struct Lexer {
        enum LexingError: Error {
            case unterminatedComment
        }

        static func tokenize(_ input: String) throws(LexingError) -> [Token] {
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
}
