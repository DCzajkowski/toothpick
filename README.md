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
mix tokenize path/to/source/file.tp # To get tokens list
mix parse path/to/source/file.tp # To get toothpick-AST
# WIP # mix compile path/to/source/file.tp # To get JavaScript-AST
# WIP # mix js path/to/source/file.tp # To get JavaScript code
# WIP # mix run path/to/source/file.tp # To get output of the program embedded in the file.tp file (runs the JavaScript compiler and runs the program with Node.JS)
```

### Running tests

```bash
mix test
```

### Running the code formatter

```bash
mix format
```
