# Toothpick
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
| mix translate.js `# translates the Toothpick AST to JS AST` \
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
