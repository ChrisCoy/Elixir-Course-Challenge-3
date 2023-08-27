defmodule GenReport do
  def build do
    {:error, "Insira o nome de um arquivo"}
  end

  def build(filename) do
    # rows[0]
    ####### STUPID WAY #######
    # rows =

    IO.inspect(filename)

    rows = GenReport.Parser.parse_file(filename)

    all_hours =
      Enum.reduce(rows, %{}, fn [name, hours | _], acc ->
        Map.update(acc, name, 0, fn value ->
          converted_value = hours

          value + converted_value
        end)
      end)

    hours_per_month =
      Enum.reduce(rows, %{}, fn [name | data], acc ->
        Map.update(acc, name, %{}, fn month_values ->
          month = Enum.at(data, 2)

          Map.update(month_values, month, 0, fn value ->
            hours = Enum.at(data, 0)
            hours = hours

            hours + value
          end)
        end)
      end)

    hours_per_year =
      Enum.reduce(rows, %{}, fn [name | data], acc ->
        Map.update(acc, name, %{}, fn month_values ->
          year = Enum.at(data, 3)

          Map.update(month_values, year, 0, fn value ->
            hours = Enum.at(data, 0)
            hours = hours

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
end
