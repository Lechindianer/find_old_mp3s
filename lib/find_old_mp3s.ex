defmodule FindOldMp3s.Main do
  use Bakeware.Script

  @impl Bakeware.Script
  def main(args) do
    path = args
      |> Path.expand

    Path.wildcard(path) |> Enum.each(fn path -> IO.puts(path) end)

    0
  end
end
