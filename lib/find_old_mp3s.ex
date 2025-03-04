defmodule FindOldMp3s.Application do
  @moduledoc """
  Main module to run when invoking the binary
  """

  @dialyzer {:no_return, show_exiftool_error: 0, start: 2}

  def start(_, _) do
    check_exif_tools()

    get_options()
    |> validate_options()
    |> execute()

    System.halt(0)
  end

  defp check_exif_tools() do
    case System.find_executable("exiftool") do
      nil -> show_exiftool_error()
      _ -> true
    end
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

    IO.puts("Running exiftool...\n")

    Stream.map(files, fn file -> {get_bitrate(file), file} end)
    |> Enum.each(fn {bitrate, path} -> IO.puts("#{bitrate}\t|\t#{path}") end)
  end

  defp show_exiftool_error() do
    IO.puts(
      :stderr,
      "This command needs to have tool 'exiftool' installed! Please consult your OS manual in order to install it."
    )

    System.halt(2)
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

  defp get_bitrate(file) do
    System.cmd("exiftool", ["-AudioBitrate", file])
    |> elem(0)
    |> String.split(":")
    |> Enum.at(1, "---")
    |> String.trim()
    |> String.pad_trailing(8)
  end
end
