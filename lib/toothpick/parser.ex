defmodule Toothpick.Parser do
  def parse(tokens) do
    %{
      type: "Program",
      body: parser(tokens),
    }
  end

  defp parser(tokens) do
    %{
      type: "FunctionDeclaration",
      id: %{
        type: "Identifier",
        name: "main"
      },
      params: [],
      body: %{
        type: "BlockStatement",
        body: [
          %{
            type: "ReturnStatement",
            argument: %{
              type: "Literal",
              value: "Hello, World!",
              raw: "'Hello, World!'"
            }
          }
        ]
      },
      generator: false,
      expression: false,
      async: false
    }
  end
end
