defmodule Mix.Tasks.Compile.Js do
  @moduledoc """
  Compiles JS AST to JS code. It also prepends the code with
  the standard library and appends the main() function call.

  This task receives a JS AST in JSON and returns JS code:

      mix compile.js file/containing/js/ast.txt

  It is also possible to pass the file contents in stdin:

      cat file/containing/js/ast.txt | mix compile.js

  ## Example

  ### Input

      echo '' | mix compile.js

  ### Output

      /* [standard library is normally included here] */
      function main() {
        return 'Hello, World!';
      }

      const statusOrPrintable = main();
      if (statusOrPrintable === 0 || statusOrPrintable === 1) {
        process.exit(statusOrPrintable);
      } else {
        console.log(statusOrPrintable);
      }
  """

  @shortdoc "Translate Toothpick AST to JS AST"

  use Mix.Task

  def run(argv) do
    preamble = Toothpick.Translator.JsTranslator.preamble()
    ending = Toothpick.Translator.JsTranslator.ending()
    content = argv |> Tasks.Helpers.ContentReader.get_content()
    command = "echo '" <> content <> "' | node node_modules/js-ast-compiler/compile.js"

    {code, 0} = System.cmd("/bin/sh", ["-c", command])

    IO.puts(preamble <> code <> ending)
  end
end
