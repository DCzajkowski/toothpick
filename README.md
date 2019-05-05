<p align="center"><img src="https://i.imgur.com/WtjJQz7.png" alt="Toothpick logo" /></p>

## Introduction

Toothpick is a programming language that compiles directly to JavaScript. It provides a modern syntax for purely functional solutions.
It has a very short list of reserved keywords and tokens which makes it very flexible.
The documentation can be found at https://toothpick.netlify.com.

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
