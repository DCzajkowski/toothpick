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
source=test/stubs/function_without_arguments.tp; \
output=_build/output.js; \
mix toothpick $source -o $output \
&& node $output
```

### Running tests

```bash
mix test
```

### Running the code formatter

```bash
mix format
```
