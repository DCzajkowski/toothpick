defmodule Toothpick.Parser do
  def parse(tokens) do
    # tokens
    # %{
    #   type: "Program",
    #   body: []
    # }
    program(tokens)
  end

  def program(tokens) do
    {children, _} = function([], tokens)

    children
  end

  def function(tree, [{:keyword, "fun"}, {:identifier, name} | tail]) do
    children = [{:keyword, "fun"}, {:identifier, name}]
    {children, tail} = body(children, tail)
    subtree = {:function_declaration, children}
    function(tree ++ [subtree], tail)
  end

  def function(tree, tail), do: {tree, tail}

  def body(tree, [{:new_line, _} | tail]) do
    {children, tail} = statement([], tail)
    subtree = {:function_body, children}
    {tree ++ [subtree], tail}
  end

  def statement(tree, [{:keyword, "return"} | tail]) do
    children = [{:keyword, "return"}]
    {children, tail} = expression(children, tail)
    subtree = {:return_statement, children}
    statement(tree ++ [subtree], tail)
  end

  def statement(tree, tail) do
    {tree, tail}
  end

  def expression(tree, [{:string, value} | tail]) do
    children = [{:string, value}]
    subtree = {:expresion, children}
    {tree ++ [subtree], tail}
  end

  # def parser(tokens) do
  #   %{
  #     type: "FunctionDeclaration",
  #     id: %{
  #       type: "Identifier",
  #       name: "main"
  #     },
  #     params: [],
  #     body: %{
  #       type: "BlockStatement",
  #       body: [
  #         %{
  #           type: "ReturnStatement",
  #           argument: %{
  #             type: "Literal",
  #             value: "Hello, World!",
  #             raw: "'Hello, World!'"
  #           }
  #         }
  #       ]
  #     },
  #     generator: false,
  #     expression: false,
  #     async: false
  #   }
  # end
end
