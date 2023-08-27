defmodule GenReport do
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

  def build(filename) do
    rows =
      filename
      |> File.stream!()
      |> Enum.map(&parse_line/1)

    # rows[0]

    ####### STUPID WAY #######

    all_hours =
      Enum.reduce(rows, %{}, fn [name, hours | _], acc ->
        Map.update(acc, String.downcase(name), 0, fn value ->
          converted_value = String.to_integer(hours)

          value + converted_value
        end)
      end)

    hours_per_month =
      Enum.reduce(rows, %{}, fn [name | data], acc ->
        Map.update(acc, String.downcase(name), %{}, fn month_values ->
          month_index = Enum.at(data, 2)
          month_index = String.to_integer(month_index)

          # minus 1 cuz array starts at zero, and months at 1
          month_key = Enum.at(@months, month_index - 1)

          Map.update(month_values, month_key, 0, fn value ->
            hours = Enum.at(data, 0)
            hours = String.to_integer(hours)

            hours + value
          end)
        end)
      end)

    hours_per_year =
      Enum.reduce(rows, %{}, fn [name | data], acc ->
        Map.update(acc, String.downcase(name), %{}, fn month_values ->
          year = Enum.at(data, 3)

          Map.update(month_values, year, 0, fn value ->
            hours = Enum.at(data, 0)
            hours = String.to_integer(hours)

            hours + value
          end)
        end)
      end)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
  end
end
