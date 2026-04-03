import ArgumentParser

extension Swirth {
    struct Compile: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Compile Forth code.",
            discussion: "Provides the ability to compile Forth code from a source file.",
            aliases: ["c"]
        )

        @Argument(help: "The path to the source code file to compile.")
        var inputPath: String

        @Option(name: .shortAndLong, help: "The compilation target (desired output type).")
        var target: Target = .asm

        func run() throws {
            let c = Compiler()

            do {
                let input = try String(contentsOfFile: inputPath, encoding: .utf8)
                let tokens = try Lexer.tokenize(input)
                let instructions = try c.emitIR(tokens)

                if case target = .ir {
                    instructions.forEach { print($0) }
                    return
                }

                let asm = c.emitASM(instructions)
                print(asm.joined(separator: "\n"))
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

extension Swirth.Target: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
