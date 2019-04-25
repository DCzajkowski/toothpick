defmodule Tasks.Helpers.ContentReader do
  def get_content(argv) do
    cond do
      length(argv) == 0 -> IO.read(:all)
      length(argv) == 1 -> argv |> List.first() |> File.read!()
      true -> raise("This task expects either 0 or 1 argument. Refer to manual for more information.")
    end
  end
end
