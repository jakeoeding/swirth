# swirth

Swirth is a minimal [Forth](https://en.wikipedia.org/wiki/Forth_(programming_language)) implemented in Swift. It supports both interpreted execution (with an interactive REPL) and compilation to ARM64 binaries on MacOS.

## Requirements
- A MacOS ARM64 machine
- Swift toolchain

## Setup

Build the project
```bash
swift build -c release
```

## Usage

### Interpret

By default, `swirth` drops into an interactive REPL:
```
swirth
```

To run a source file and then enter the REPL:
```bash
swirth interpret -i <file>
```

To run a source file without the REPL:
```bash
swirth interpret -i <file> --no-repl
```

### Compile

Compile a source file to a binary (utilizes `clang` for assembling and linking the generated assembly):
```bash
swirth compile <file> -o <output>
```

Compile to ARM64 assembly with `-t asm`, or the Swirth intermediate representation with `-t ir`.
