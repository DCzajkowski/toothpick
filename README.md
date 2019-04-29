<p align="center"><img src="https://i.imgur.com/WtjJQz7.png" alt="Toothpick logo" /></p>

## Introduction

Toothpick is a programming language that compiles directly to JavaScript. It provides a modern syntax for purely functional solutions. It has a very short list of reserved keywords and tokens which makes it very flexible.

## Installation
### Prerequisites

* Elixir 1.8 & Mix (`brew install elixir` on macOS)

### Installation steps

```bash
git clone git@github.com:DCzajkowski/toothpick.git
cd toothpick
```

### Compiling and running the application

```bash
mix tokenize test/stubs/function_without_arguments.tp `# returns the tokens list` \
| mix parse `# parses the tokens list and returns the Toothpick AST` \
| mix translate `# translates the Toothpick AST to JS AST` \
| node node_modules/js-ast-compiler/compile.js `# compiles the JS AST to JS code` \
| node `# runs the code`
```

### Running tests

```bash
mix test
```

### Running the code formatter

```bash
mix format
```
