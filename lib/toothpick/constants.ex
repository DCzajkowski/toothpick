defmodule Toothpick.Constants do
  defmacro __using__(_options) do
    quote do
      defp get(:punctuators) do
        ["->", "(", ")", ".", ","]
      end

      defp get(:new_line_chars) do
        ["\n", "\r\n"]
      end

      defp get(:keywords) do
        ["fun", "return"]
      end
    end
  end
end
