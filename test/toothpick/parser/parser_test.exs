defmodule ParserTest do
  import Toothpick.Parser, only: [parse: 1, statement: 2]
  use ExUnit.Case
  use Snapshy

  doctest Toothpick.Parser

  test_snapshot "correctly parses function without arguments" do
    parse(
      keyword: "fun",
      identifier: "main",
      punctuator: "->",
      new_line: "\n",
      keyword: "return",
      string: "Hello, World!",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end

  test_snapshot "correctly parses function with arguments" do
    parse(
      keyword: "fun",
      identifier: "add",
      variable: "a",
      variable: "b",
      punctuator: "->",
      new_line: "\n",
      keyword: "return",
      variable: "a",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end

  test_snapshot "correctly parses complicated function call" do
    parse(
      keyword: "fun",
      identifier: "add",
      variable: "a",
      variable: "b",
      punctuator: "->",
      new_line: "\n",
      variable: "a",
      punctuator: "(",
      identifier: "stop",
      punctuator: "(",
      punctuator: ")",
      punctuator: ",",
      variable: "b",
      punctuator: ")",
      punctuator: "(",
      punctuator: ")",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end

  test_snapshot "correctly parses if statement with no else clauses" do
    statement(
      [],
      keyword: "if",
      new_line: "\n",
      variable: "a",
      punctuator: ":",
      keyword: "return",
      integer: "1",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end

  test_snapshot "correctly parses if statement with else clauses" do
    statement(
      [],
      keyword: "if",
      new_line: "\n",
      variable: "a",
      punctuator: ":",
      keyword: "return",
      integer: "1",
      new_line: "\n",
      identifier: "cond",
      punctuator: "(",
      variable: "a",
      punctuator: ",",
      integer: "4",
      punctuator: ")",
      punctuator: ":",
      keyword: "return",
      integer: "2",
      new_line: "\n",
      boolean: "true",
      punctuator: ":",
      keyword: "return",
      integer: "3",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end

  test_snapshot "correctly parses oneline if statement in function" do
    parse(
      keyword: "fun",
      identifier: "main",
      punctuator: "->",
      new_line: "\n",
      keyword: "if",
      variable: "cond",
      punctuator: ":",
      keyword: "return",
      integer: "1",
      new_line: "\n",
      keyword: "return",
      integer: "2",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end

  test_snapshot "correctly parses multiline if statement in function" do
    parse(
      keyword: "fun",
      identifier: "main",
      punctuator: "->",
      new_line: "\n",
      keyword: "if",
      variable: "cond",
      punctuator: ":",
      new_line: "\n",
      identifier: "cond",
      punctuator: "(",
      variable: "a",
      punctuator: ",",
      integer: "4",
      punctuator: ")",
      new_line: "\n",
      keyword: "return",
      integer: "1",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n",
      keyword: "return",
      integer: "2",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end

  test_snapshot "correctly parses if statement in function" do
    parse(
      keyword: "fun",
      identifier: "main",
      punctuator: "->",
      new_line: "\n",
      keyword: "if",
      new_line: "\n",
      variable: "cond",
      punctuator: ":",
      keyword: "return",
      integer: "1",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end

  test_snapshot "correctly parses an advanced function with multiple if statements and multiple cases" do
    parse(
      keyword: "fun",
      identifier: "main",
      punctuator: "->",
      new_line: "\n",
      keyword: "if",
      new_line: "\n",
      variable: "cond",
      punctuator: ":",
      keyword: "return",
      integer: "1",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n",
      keyword: "if",
      new_line: "\n",
      identifier: "lte",
      punctuator: "(",
      variable: "num",
      punctuator: ",",
      integer: "1",
      punctuator: ")",
      punctuator: ":",
      keyword: "return",
      identifier: "format",
      punctuator: "(",
      string: "$ is not a prime number",
      punctuator: ",",
      variable: "num",
      punctuator: ")",
      new_line: "\n",
      identifier: "contains",
      punctuator: "(",
      identifier: "range",
      punctuator: "(",
      integer: "2",
      punctuator: ",",
      variable: "num",
      punctuator: ")",
      punctuator: ",",
      boolean: "true",
      punctuator: ")",
      punctuator: ":",
      keyword: "return",
      identifier: "format",
      punctuator: "(",
      string: "$ is not a prime number",
      punctuator: ",",
      variable: "num",
      punctuator: ")",
      new_line: "\n",
      boolean: "true",
      punctuator: ":",
      keyword: "return",
      identifier: "format",
      punctuator: "(",
      string: "$ is a prime number",
      punctuator: ",",
      variable: "num",
      punctuator: ")",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n",
      punctuator: ".",
      new_line: "\n"
    )
  end
end
