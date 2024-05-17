defmodule FindOldMp3s.Application do
  @moduledoc """
  Main module to run when invoking the binary
  """

  def start(_, _) do
    args = Burrito.Util.Args.get_arguments()
    |> parse_options
    |> execute
  end

  defp parse_options(args) do
    options = OptionParser.parse(
      args,
      switches: [path: :string, type: :string, help: :boolean],
      aliases: [p: :path, t: :type, h: :help]
    )

    case options do
      {opts, [], []} ->
        {:ok, opts}

      {opts, b, c} ->
        {:error, :parsing_error}
    end
  end

  defp execute() do
   System.halt(0)
  end
end
