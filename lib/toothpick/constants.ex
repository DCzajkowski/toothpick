defmodule Toothpick.Constants do
  defmacro __using__(_options) do
    quote do
      def get(:punctuator) do
        ["->", "(", ")", ".", ","]
      end
      def get(:new_line) do
        ["\n", "\r\n"]
      end
    end
  end
end
