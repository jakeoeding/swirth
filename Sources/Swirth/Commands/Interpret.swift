import ArgumentParser

extension Swirth {
    struct Interpret: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Interpret Forth code.",
            discussion: "Provides the ability to execute Forth code from a source file, interactive REPL, or a combination of the two."
        )

        @Option(name: .shortAndLong, help: "The path to the source code file to interpret.")
        var inputPath: String?

        @Flag(name: .shortAndLong, help: "Skip the interactive REPL.")
        var noRepl = false

        func run() throws {
            let c = Compiler()
            let vm = VirtualMachine()

            do {
                if let inputPath {
                    let input = try String(contentsOfFile: inputPath, encoding: .utf8)
                    try interpret(compiler: c, vm: vm, source: input)
                }

                guard !noRepl else { return }

                while let line = readLine() {
                    try interpret(compiler: c, vm: vm, source: line)
                    print("ok")
                }
            } catch {
                print("Error: \(error)")
            }
        }

        private func interpret(compiler: Compiler, vm: VirtualMachine, source: String) throws {
            let tokens = try Lexer.tokenize(source)
            let instructions = try compiler.emitIR(tokens)
            try vm.evaluate(instructions)
        }
    }
}
