import ArgumentParser

extension Swirth {
    struct Repl: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "A read-eval-print-loop (REPL) for Swirth.",
        )

        mutating func run() throws {
            let compiler = Compiler()
            let vm = VirtualMachine()

            while let line = readLine() {
                do {
                    let tokens = try Lexer.tokenize(line)
                    let instructions = try compiler.emitIR(tokens)
                    try vm.evaluate(instructions)
                    print("ok")
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}
