import Testing
import SwirthCore

struct LexerCase {
    let input: String
    let expected: [Token]
}

@Test(arguments: [
    LexerCase(input: "1", expected: [Token.literal(.int(1))]),
    LexerCase(input: "true", expected: [Token.literal(.bool(.true))]),
    LexerCase(input: "false", expected: [Token.literal(.bool(.false))]),
    LexerCase(input: "+", expected: [Token.word(.add)]),
    LexerCase(input: "/", expected: [Token.word(.divide)]),
    LexerCase(input: "*", expected: [Token.word(.multiply)]),
    LexerCase(input: "-", expected: [Token.word(.subtract)]),
    LexerCase(input: "=", expected: [Token.word(.equal)]),
    LexerCase(input: "<>", expected: [Token.word(.notEqual)]),
    LexerCase(input: ">", expected: [Token.word(.greaterThan)]),
    LexerCase(input: ">=", expected: [Token.word(.greaterThanOrEqual)]),
    LexerCase(input: "<", expected: [Token.word(.lessThan)]),
    LexerCase(input: "<=", expected: [Token.word(.lessThanOrEqual)]),
    LexerCase(input: "<=", expected: [Token.word(.lessThanOrEqual)]),
    LexerCase(input: "lshift", expected: [Token.word(.lshift)]),
    LexerCase(input: "rshift", expected: [Token.word(.rshift)]),
    LexerCase(input: "max", expected: [Token.word(.max)]),
    LexerCase(input: "min", expected: [Token.word(.min)]),
    LexerCase(input: ".", expected: [Token.word(.dot)]),
    LexerCase(input: "dup", expected: [Token.word(.dup)]),
    LexerCase(input: "swap", expected: [Token.word(.swap)]),
    LexerCase(input: "drop", expected: [Token.word(.drop)]),
    LexerCase(input: ":", expected: [Token.delimiter(.functionStart)]),
    LexerCase(input: ";", expected: [Token.delimiter(.functionEnd)]),
])
func producesBasicTokens(_ example: LexerCase) throws {
    #expect(try Lexer.tokenize(example.input) == example.expected)
}

@Test
func handlesMultipleTokens() throws {
    #expect(try Lexer.tokenize("1 2 + .") == [
        Token.literal(.int(1)),
        Token.literal(.int(2)),
        Token.word(.add),
        Token.word(.dot),
    ])
}

@Test
func handlesExcessiveWhitespace() throws {
    #expect(
        try Lexer.tokenize(" 1      2  +    .    ") == [
            Token.literal(.int(1)),
            Token.literal(.int(2)),
            Token.word(.add),
            Token.word(.dot),
        ]
    )
}

@Test(arguments: [
    LexerCase(input: "( 1 2 3 )", expected: []),
    LexerCase(input: "1 ( 1 2 3 ) .", expected: [Token.literal(.int(1)), Token.word(.dot)]),
])
func ignoresComments(_ example: LexerCase) throws {
    #expect(try Lexer.tokenize(example.input) == example.expected)
}

@Test
func throwsForUnterminatedComments() {
    #expect(throws: Lexer.LexingError.unterminatedComment) {
        try Lexer.tokenize("1 2 ( oops")
    }
}

@Test
func handlesIdentifiers() throws {
    #expect(try Lexer.tokenize("1 2 sq .") == [
        Token.literal(.int(1)),
        Token.literal(.int(2)),
        Token.identifier("sq"),
        Token.word(.dot),
    ])
}
