import Testing
import SwirthCore

// MARK: emitIR

struct CompilerCase {
    let input: [Token]
    let expected: [Instruction]
}

@Test(arguments: [
    CompilerCase(input: [.literal(.int(1))], expected: [.push(1)]),
    CompilerCase(input: [.literal(.bool(.true))], expected: [.push(-1)]),
    CompilerCase(input: [.literal(.bool(.false))], expected: [.push(0)]),
])
func withLiterals(_ example: CompilerCase) throws {
    let c = Compiler()
    #expect(try c.emitIR(example.input) == example.expected)
}

@Test(arguments: [
    CompilerCase(input: [.word(.dot)], expected: [.dot]),
    CompilerCase(input: [.word(.dup)], expected: [.dup]),
    CompilerCase(input: [.word(.add)], expected: [.add]),
    CompilerCase(input: [.word(.divide)], expected: [.divide]),
    CompilerCase(input: [.word(.equal)], expected: [.equal]),
    CompilerCase(input: [.word(.notEqual)], expected: [.notEqual]),
    CompilerCase(input: [.word(.greaterThan)], expected: [.greaterThan]),
    CompilerCase(input: [.word(.greaterThanOrEqual)], expected: [.greaterThanOrEqual]),
    CompilerCase(input: [.word(.lessThan)], expected: [.lessThan]),
    CompilerCase(input: [.word(.lessThanOrEqual)], expected: [.lessThanOrEqual]),
    CompilerCase(input: [.word(.multiply)], expected: [.multiply]),
    CompilerCase(input: [.word(.subtract)], expected: [.subtract]),
    CompilerCase(input: [.word(.swap)], expected: [.swap]),
    CompilerCase(input: [.word(.drop)], expected: [.drop]),
    CompilerCase(input: [.word(.lshift)], expected: [.lshift]),
    CompilerCase(input: [.word(.rshift)], expected: [.rshift]),
    CompilerCase(input: [.word(.max)], expected: [.max]),
    CompilerCase(input: [.word(.min)], expected: [.min]),
])
func withWords(_ example: CompilerCase) throws {
    let c = Compiler()
    #expect(try c.emitIR(example.input) == example.expected)
}

@Test
func emitsNoInstructionsForFunctionDefinitions() throws {
    let c = Compiler()

    let tokens: [Token] = [
        .delimiter(.functionStart),
        .identifier("foo"),
        .word(.dot),
        .delimiter(.functionEnd),
    ]

    #expect(try c.emitIR(tokens).isEmpty)
}

@Test
func emitsInstructionsForFunctionInvocations() throws {
    let c = Compiler()

    let tokens: [Token] = [
        // definition
        .delimiter(.functionStart),
        .identifier("foo"),
        .word(.dot),
        .delimiter(.functionEnd),
        // invocation
        .identifier("foo"),
    ]

    #expect(try c.emitIR(tokens) == [.dot])
}

@Test
func throwsForFunctionEndDelimiterOutsideFunctionDefinition() throws {
    let c = Compiler()

    let tokens: [Token] = [
        .literal(.int(1)),
        .delimiter(.functionEnd),
    ]

    #expect(throws: Compiler.CompilationError.invalidDefinitionTermination) {
        try c.emitIR(tokens)
    }
}

@Test
func throwsForUnknownIdentifiers() throws {
    let c = Compiler()
    #expect(throws: Compiler.CompilationError.undefinedWord("foo")) {
        try c.emitIR([.identifier("foo")])
    }
}

// MARK: emitAsm

@Test
func includesIOOnlyDirectivesWhenUsingDot() {
    let c = Compiler()
    let asm = c.emitASM([.dot]).joined()
    #expect(asm.contains("extern _printf"))
    #expect(asm.contains(".section __TEXT,__cstring"))
}

@Test
func doesNotIncludeIOOnlyDirectivesWhenUsingDot() {
    let c = Compiler()
    let asm = c.emitASM([.push(4)]).joined()
    #expect(!asm.contains("extern _printf"))
    #expect(!asm.contains(".section __TEXT,__cstring"))
}
