defmodule Mix.Tasks.Toothpick do
  @moduledoc """
  Compiles Toothpick source code and runs it.

  This task receives toothpick source code file as the first argument:

      mix toothpick path/to/source/code.tp

  ## Command-line options

    * `--output [filename]` - writes compiled JS code to the given file.
    If `filename` is ":stdout", then the output will be written to stdout.

  ## Example

      mix toothpick test/stubs/function_without_arguments.tp -o output.js

  """

  @shortdoc "Translate Toothpick AST to JS AST"

  use Mix.Task
  import Toothpick.Translator.JsTranslator, only: [preamble: 0, ending: 0]

  def run(argv) do
    {flags, [filename | _], _} = OptionParser.parse(argv, strict: [output: :string], aliases: [o: :output])

    code =
      filename
      |> File.read!()
      |> Toothpick.Tokenizer.tokens()
      |> Toothpick.Parser.parse()
      |> Toothpick.Translator.JsTranslator.translate()
      |> ESTree.Tools.ESTreeJSONTransformer.convert()
      |> ESTree.Tools.Generator.generate()

    output_name = flags[:output]
    output = preamble() <> code <> ending()

    if output_name == ":stdout" do
      IO.puts(output)
    else
      File.write!(output_name, output)
    end
  end

  def main(argv), do: run(argv)
end
