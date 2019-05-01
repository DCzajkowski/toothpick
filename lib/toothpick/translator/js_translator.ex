defmodule Toothpick.Translator.JsTranslator do
  def translate(tree) do
    %{
      "type" => "Program",
      "body" => program_body([], tree)
    }
  end

  def preamble() do
    """
    /**
    * This is a compiled program output via the Toothpick compiler.
    * The following sections are in order: the standard library,
    * Toothpick program's compiled source code, the main()
    * function call and the exit status.
    */

    /**
    * The standard library
    */

    // helpers
    const __deepClone__ = value => JSON.parse(JSON.stringify(value));

    // IO
    const print = string => console.log(string);
    const inspect = value => console.log(typeof value, value);

    // String
    function format() {
      let [string, ...values] = arguments;
      values = [].concat(...values);

      if (values.length === 0) {
        return string;
      }

      const match = string.match(/(^\\$)|([^\\\\])\\$/);
      const index = match['index'];

      if (index === 0) {
        const result = String(values[0]) + string.substring(1);

        return format(result, values.slice(1));
      }

      const result =
        string.substring(0, index) +
        match[2] +
        String(values[0]) +
        string.substring(index + 2);

      return format(result, values.slice(1));
    }

    // Logic
    const sif = (bool, a, b) => (bool ? a : b);
    const and = (a, b) => a && b;
    const or = (a, b) => a || b;
    const not = a => !a;
    const eq = (a, b) => a === b;
    const lt = (a, b) => a < b;
    const gt = (a, b) => a > b;
    const lte = (a, b) => a <= b;
    const gte = (a, b) => a >= b;

    // Math
    const add = (a, b) => a + b;
    const sub = (a, b) => a - b;
    const mul = (a, b) => a * b;
    const div = (a, b) => a / b;
    const mod = (a, b) => a % b;
    const pow = (a, b) => a ** b;

    // Lists
    const map = (list, lambda) => list.map(lambda);
    const filter = (list, lambda) => list.filter(lambda);
    const find = (list, lambda) => list.find(lambda);
    const every = (list, lambda) => list.every(lambda);
    const some = (list, lambda) => list.some(lambda);
    const flatten = list => [].concat(...list);
    const each = (list, lambda) => list.forEach(lambda);
    const push = (list, element) => [...list, element];
    const pop = (list, index = null) =>
      list[index === null ? list.length - 1 : index];
    const first = list => list[0];
    const last = list => list[list.length - 1];
    const reduce = (list, lambda, accumulator) => list.reduce(lambda, accumulator);
    const reverse = list => __deepClone__(list).reverse();
    const diff = (a, b) => a.filter(e => !b.includes(e));
    const range = (start, end, step = 1) => {
      const result = [];
      let current = start;

      while (current < end) {
        result.push(current);
        current += step;
      }

      return result;
    };
    const merge = (a, b) => [...a, ...b];
    const length = list => list.length;
    const contains = (list, element) => list.includes(element);
    const sort = list => __deepClone__(list).sort();
    const sum = list => list.reduce((e, a) => e + a, 0);
    const join = (list, sep) => list.join(sep);

    // Misc
    const raise = string => {
      throw string;
    };

    /**
    * Toothpick compiled source code
    */

    """
  end

  def ending() do
    """


    /**
    * The main() function call and the exit status.
    */

    const statusOrPrintable = main();

    if (statusOrPrintable === 0 || statusOrPrintable === 1) {
      process.exit(statusOrPrintable);
    } else {
      console.log(statusOrPrintable);
    }
    """
  end

  def program_body(tree, [{:function_declaration, function_declaration} | tail]),
    do: program_body(tree ++ [function_declaration(function_declaration)], tail)

  def program_body(tree, tail), do: tree ++ tail

  def function_declaration(
        identifier: name,
        function_arguments: function_arguments,
        function_body: body
      ) do
    %{
      "type" => "FunctionDeclaration",
      "id" => %{"name" => name, "type" => "Identifier"},
      "params" => function_arguments([], function_arguments),
      "body" => %{
        "type" => "BlockStatement",
        "body" => function_body([], body)
      }
    }
  end

  def function_arguments(tree, [{:variable, variable} | tail]),
    do: function_arguments(tree ++ [expression({:variable, variable})], tail)

  def function_arguments(tree, []), do: tree

  def function_body(tree, [{:return_statement, return_statement} | tail]) do
    children = [
      %{
        "type" => "ReturnStatement",
        "argument" => expression(return_statement)
      }
    ]

    function_body(tree ++ children, tail)
  end

  def function_body(tree, [{:if_statement, if_statement} | tail]) do
    function_body(
      tree ++
        [
          %{
            "type" => "IfStatement",
            "test" => expression(if_statement[:condition]),
            "consequent" => %{
              "type" => "BlockStatement",
              "body" => function_body([], [if_statement[:yes]])
            },
            "alternate" =>
              if(length(if_statement[:no]) != 0,
                do: %{
                  "type" => "BlockStatement",
                  "body" => function_body([], if_statement[:no])
                },
                else: nil
              )
          }
        ],
      tail
    )
  end

  def function_body(tree, tail), do: tree ++ tail

  def expression({:string, string}), do: %{"type" => "Literal", "value" => string}

  def expression({:integer, integer}) do
    {integer, ""} = Integer.parse(integer)
    %{"type" => "Literal", "value" => integer}
  end

  def expression({:boolean, boolean}),
    do: %{"type" => "Literal", "value" => if(boolean == "true", do: true, else: false)}

  def expression({:variable, variable}), do: %{"type" => "Identifier", "name" => variable}

  def expression({:function_call, function_call}) do
    {:identifier, name} = function_call[:calle]

    %{
      "type" => "CallExpression",
      "callee" => %{
        "type" => "Identifier",
        "name" => name
      },
      "arguments" => arguments([], function_call[:args])
    }
  end

  def arguments(tree, [argument | tail]), do: arguments(tree ++ [expression(argument)], tail)
  def arguments(tree, []), do: tree
end
