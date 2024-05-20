defmodule FindOldMp3s.Application do
  @moduledoc """
  Main module to run when invoking the binary
  """

  def start(_, _) do
    get_options()
    |> validate_options()
    |> execute()

    System.halt(0)
  end

  defp get_options() do
    Burrito.Util.Args.get_arguments()
    |> OptionParser.parse(
      strict: [path: :string, type: :keep, help: :boolean],
      aliases: [p: :path, t: :type, h: :help]
    )
  end

  defp validate_options({[], [], []}), do: {:error, :no_parameters}

  defp validate_options({parsed, _argv, _errors}) do
    cond do
      Keyword.has_key?(parsed, :help) ->
        {:error, :show_help}

      Keyword.has_key?(parsed, :path) and Keyword.has_key?(parsed, :type) ->
        {:ok, parsed}

      true ->
        {:error, :missing_parameter}
    end
  end

  defp execute({:error, :no_parameters}) do
    IO.warn("No options given!")

    print_help()
    System.halt(1)
  end

  defp execute({:error, :show_help}) do
    print_help()
    System.halt(1)
  end

  defp execute({:error, :missing_parameter}) do
    IO.warn("Both parameters 'type' and 'path' must be set!")

    print_help()
    System.halt(1)
  end

  defp execute({:ok, opts}) do
    file_types =
      Keyword.get_values(opts, :type)
      |> Enum.join(",")

    file_path =
      Keyword.get(opts, :path)
      |> Path.expand()

    files = Path.wildcard("#{file_path}/**/*.{#{file_types}}")

    if Enum.empty?(files) do
      IO.puts("No files found")
      System.halt(0)
    end

    Enum.each(files, fn file -> IO.puts(file) end)
  end

  defp print_help() do
    IO.puts("""
    This command will find audio files with low bitrates in a folder folder (recursively) and shows the bitrate and
    path to those files.

    DESCRIPTION

      Possible options:
        Long option    short option    description
        --help         -h              Show this help
        --type         -t              Give some file audio file type ending like 'ogg' or 'mp3' - can be used multiple
                                       times
        --path         -p              Root path to search files, search will be recursive

    EXAMPLE

      find_old_mp3s --path "~" --type "ogg" --type "mp3"

    """)
  end
end
