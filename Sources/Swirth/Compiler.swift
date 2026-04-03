extension Swirth {
    final class Compiler {
        enum CompilationError: Error {
            case invalidDefinitionTermination
            case undefinedWord(String)
        }

        var definitions = [String: [Instruction]]()

        func emitIR(_ tokens: [Token]) throws(CompilationError) -> [Instruction] {
            var outputStack: [[Instruction]] = [[]]

            var currentDefinition: String?
            var currentOutput: [Instruction] {
                get { outputStack[outputStack.count - 1] }
                set { outputStack[outputStack.count - 1] = newValue }
            }

            for token in tokens {
                switch token {
                case .literal(let value):
                    switch value {
                    case .int(let i):
                        currentOutput.append(.push(i))
                    case .bool(let b):
                        currentOutput.append(.push(b.rawValue))
                    }
                case .word(let op):
                    switch op {
                    case .dot:
                        currentOutput.append(.dot)
                    case .dup:
                        currentOutput.append(.dup)
                    case .add:
                        currentOutput.append(.add)
                    case .divide:
                        currentOutput.append(.divide)
                    case .equal:
                        currentOutput.append(.equal)
                    case .greaterThan:
                        currentOutput.append(.greaterThan)
                    case .greaterThanOrEqual:
                        currentOutput.append(.greaterThanOrEqual)
                    case .lessThan:
                        currentOutput.append(.lessThan)
                    case .lessThanOrEqual:
                        currentOutput.append(.lessThanOrEqual)
                    case .multiply:
                        currentOutput.append(.multiply)
                    case .subtract:
                        currentOutput.append(.subtract)
                    case .swap:
                        currentOutput.append(.swap)
                    case .drop:
                        currentOutput.append(.drop)
                    }
                case .delimiter(let d):
                    switch d {
                    case .functionStart:
                        outputStack.append([])
                    case .functionEnd:
                        if currentDefinition == nil {
                            throw .invalidDefinitionTermination
                        }

                        definitions[currentDefinition!] = outputStack.removeLast()
                        currentDefinition = nil
                    }
                case .identifier(let id):
                    if currentDefinition == nil && outputStack.count > 1 {
                        currentDefinition = id
                        continue
                    }

                    guard let instructionsForId = definitions[id] else {
                        throw .undefinedWord(id)
                    }

                    currentOutput.append(contentsOf: instructionsForId)
                }
            }

            return outputStack.removeLast()
        }

        func emitASM(_ instructions: [Instruction]) -> [String] {
            var output = [String]()

            let includeIO = instructions.contains { if case .dot = $0 { true } else { false } }

            output.append(contentsOf: preamble(includeIO: includeIO))
            output.append(contentsOf: mainSetup())

            for instruction in instructions {
                switch instruction {
                case .push(let i):
                    output.append(contentsOf: pushStack(value: i))
                case .dot:
                    output.append("    adrp x0, fmt@PAGE")
                    output.append("    add  x0, x0, fmt@PAGEOFF")

                    output.append("    sub  sp, sp, #16")
                    output.append(contentsOf: popStack(register: 8))
                    output.append("    str  x8, [sp]")

                    output.append("    bl   _printf")
                    output.append("    add  sp, sp, #16")
                case .dup:
                    output.append("    ldr  x8, [x19, #-8]")
                    output.append(contentsOf: pushStackFrom(register: 8))
                default:
                    fatalError("`\(instruction)` not implemented")
                }
            }

            output.append(contentsOf: exitWithCode(0))

            if includeIO {
                output.append(contentsOf: stringSection())
            }

            output.append(contentsOf: bssSection())

            return output
        }

        private func preamble(includeIO: Bool) -> [String] {
            var preamble = [
                ".section __TEXT,__text",
                ".global _main",
                ".extern _exit",
            ]

            if includeIO {
                preamble.append(".extern _printf")
            }

            return preamble
        }

        private func mainSetup() -> [String] {
            return [
                "",
                "_main:",
                "    adrp x19, stack@GOTPAGE",
                "    ldr  x19, [x19, stack@GOTPAGEOFF]"
            ]
        }

        private func exitWithCode(_ code: Int) -> [String] {
            return [
                "    mov  x0, #0",
                "    bl   _exit"
            ]
        }

        private func stringSection() -> [String] {
            return [
                "",
                ".section __TEXT,__cstring",
                "fmt:",
                "    .asciz \"%d\\n\""
            ]
        }

        private func bssSection() -> [String] {
            return [
                "",
                ".section __DATA,__bss",
                ".align 3",
                "stack:",
                "    .skip 8192"
            ]
        }

        private func pushStack(value: Int) -> [String] {
            return [
                "    mov  x8, #\(value)",
                "    str  x8, [x19]",
                "    add  x19, x19, #8",
            ]
        }

        private func pushStackFrom(register: Int) -> [String] {
            return [
                "    str  x\(register), [x19]",
                "    add  x19, x19, #8",
            ]
        }

        private func popStack(register: Int) -> [String] {
            return [
                "    sub  x19, x19, #8",
                "    ldr  x\(register), [x19]"
            ]
        }
    }
}
