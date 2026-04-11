import ArgumentParser

@main
struct SwirthCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A minimal Forth implemented in Swift.",
        subcommands: [Interpret.self, Compile.self],
        defaultSubcommand: Interpret.self
    )
}
