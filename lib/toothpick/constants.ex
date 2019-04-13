defmodule Toothpick.Constants do
  defmacro __using__(_options) do
    quote do
      def get(:punctuators) do
        ["->", "(", ")", ".", ",", "[", "]", ">", "$"]
      end

      def get(:new_line_chars) do
        ["\n", "\r\n"]
      end

      def get(:keywords) do
        ["fun", "return", "if", "elif", "else"]
      end
    end
  end
end
