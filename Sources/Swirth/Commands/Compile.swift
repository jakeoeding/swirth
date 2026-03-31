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

        func run() throws {
            let c = Compiler()

            do {
                let input = try String(contentsOfFile: inputPath, encoding: .utf8)
                let tokens = try Lexer.tokenize(input)
                let instructions = try c.emitIR(tokens)
                instructions.forEach { print($0) }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
