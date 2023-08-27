defmodule GenReport.Parser do
  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [name, hour, day, month, year] =
      line
      |> String.trim()
      |> String.split(",")

    name = String.downcase(name)
    hour = String.to_integer(hour)
    day = String.to_integer(day)
    year = String.to_integer(year)
    month = Enum.at(@months, String.to_integer(month) - 1)

    [name, hour, day, month, year]
  end
end
