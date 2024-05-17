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

  defp execute({:error, :parsing_error}) do
    IO.puts """
    Help command output

    Possible options:
      Long option    short option    description
      --help         -h              Show this help
      --type         -t              Give some file audio file type ending like 'ogg' or 'mp3'
      --path         -p              Root path to search files, search will be recursive
    """

    System.halt(1)
  end

  defp execute() do
   System.halt(0)
  end
end
