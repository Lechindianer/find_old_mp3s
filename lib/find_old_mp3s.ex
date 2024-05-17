defmodule FindOldMp3s.Application do
  @moduledoc """
  Main module to run when invoking the binary
  """

  def start(_, _) do
    args = Burrito.Util.Args.get_arguments()
    |> parse_options
    |> execute
  end
end
