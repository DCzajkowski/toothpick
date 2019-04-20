defmodule Toothpick.Constants do
  defmacro __using__(_options) do
    quote do
      def get(:punctuators), do: ["->", "(", ")", ".", ",", "[", "]", ">", "$"]
      def get(:new_line_chars), do: ["\n", "\r\n"]
      def get(:keywords), do: ["fun", "return", "if", "elif", "else"]
      def get(:booleans), do: ["true", "false"]
    end
  end
end
