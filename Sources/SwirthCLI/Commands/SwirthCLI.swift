import ArgumentParser

@main
struct SwirthCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swirth",
        abstract: "A minimal Forth implemented in Swift.",
        subcommands: [Interpret.self, Compile.self],
        defaultSubcommand: Interpret.self
    )
}
