defmodule Mix.Tasks.Toothpick do
  @moduledoc """
  Compiles Toothpick source code and runs it.

  This task receives toothpick source code file as the first argument:

      mix toothpick path/to/source/code.tp

  ## Command-line options

    * `-o [filename]` - displays compiled JS code instead of running it. If
    the `filename` argument is provided, the output will be written to the
    `filename`.

  ## Example

  ### Input

      mix toothpick test/stubs/function_without_arguments.tp

  ### Output

      Hello, World!

  """

  @shortdoc "Translate Toothpick AST to JS AST"

  use Mix.Task

  def run(argv) do
    [filename | flags] = argv

    command = """
    mix compile \
    && mix tokenize #{filename} \
    | mix parse \
    | mix translate.js \
    | mix compile.js \
    """

    command =
      if Enum.member?(flags, "-o") do
        index = Enum.find_index(flags, fn el -> el === "-o" end)

        pair = Enum.slice(flags, index, 2)

        if Kernel.length(pair) === 2 do
          [_, output_filename] = pair

          command <> " > " <> output_filename
        else
          command
        end
      else
        command <> " | node"
      end

    {output, 0} = System.cmd("/bin/sh", ["-c", command])

    if Enum.member?(flags, "--no-stdout") do
      output
    else
      IO.puts(output)
    end
  end
end
