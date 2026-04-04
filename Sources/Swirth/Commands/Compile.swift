import ArgumentParser
import Foundation
import Subprocess

extension Swirth {
    struct Compile: AsyncParsableCommand {
        enum CompileError: Error {
            case clangError(String)
        }

        static let configuration = CommandConfiguration(
            abstract: "Compile Forth code.",
            discussion: "Provides the ability to compile Forth code from a source file.",
            aliases: ["c"]
        )

        @Argument(help: "The path to the source code file to compile.")
        var inputPath: String

        @Option(name: .shortAndLong, help: "The compilation target (desired output type).")
        var target: Target = .binary

        @Option(name: .shortAndLong, help: "The desired output file path.")
        var outputPath: String = "output"

        func run() async throws {
            let c = Compiler()

            let input = try String(contentsOfFile: inputPath, encoding: .utf8)
            let tokens = try Lexer.tokenize(input)
            let instructions = try c.emitIR(tokens)

            switch target {
            case .ir:
                let ir = instructions.map { "\($0)" }.joined(separator: "\n")
                try ir.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: .utf8)
                return
            case .asm:
                let asm = c.emitASM(instructions).joined(separator: "\n")
                try asm.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: .utf8)
                return
            case .binary:
                let asm = c.emitASM(instructions).joined(separator: "\n")

                let result = try await Subprocess.run(
                    .name("clang"),
                    arguments: ["-x", "assembler", "-", "-o", outputPath],
                    input: .string(asm),
                    output: .string(limit: 4096),
                    error: .string(limit: 4096)
                )

                guard result.terminationStatus.isSuccess else {
                    throw CompileError.clangError(result.standardError ?? "clang failure")
                }
            }
        }
    }
}

extension Swirth.Target: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
